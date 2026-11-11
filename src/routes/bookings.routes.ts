import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../db/pool.js';
import { requireAuth } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

const bookingSchema = z.object({
  labId: z.string().uuid(),
  testId: z.string().uuid(),
  collectionType: z.enum(['home', 'lab']),
  bookingDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  timeSlot: z.string().trim().min(3).max(50),
  patientName: z.string().trim().min(2).max(120),
  patientPhone: z.string().trim().min(7).max(20),
  address: z.string().trim().max(500).optional().or(z.literal(''))
});

router.post('/', async (req, res, next) => {
  const parsed = bookingSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ message: 'Invalid booking details.', errors: parsed.error.flatten() });

  const data = parsed.data;
  if (data.collectionType === 'home' && !data.address) {
    return res.status(400).json({ message: 'Address is required for home collection.' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const priceResult = await client.query(
      `SELECT p.price, p.available, l.home_collection
       FROM lab_test_prices p
       JOIN labs l ON l.id = p.lab_id
       WHERE p.lab_id = $1 AND p.test_id = $2 AND l.is_active = TRUE`,
      [data.labId, data.testId]
    );
    const price = priceResult.rows[0];
    if (!price || !price.available) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: 'This test is not currently available at the selected lab.' });
    }
    if (data.collectionType === 'home' && !price.home_collection) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: 'Home collection is not available at this lab.' });
    }
    const result = await client.query(
      `INSERT INTO bookings
       (user_id, lab_id, test_id, collection_type, booking_date, time_slot,
        patient_name, patient_phone, address, amount)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
       RETURNING id, user_id, lab_id, test_id, collection_type, booking_date,
                 time_slot, patient_name, patient_phone, address, amount, status, created_at`,
      [req.user!.id, data.labId, data.testId, data.collectionType, data.bookingDate,
       data.timeSlot, data.patientName, data.patientPhone, data.address || null, price.price]
    );
    await client.query('COMMIT');
    return res.status(201).json({ message: 'Booking confirmed.', booking: result.rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    next(error);
  } finally {
    client.release();
  }
});

router.get('/', async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT b.id, b.collection_type, b.booking_date, b.time_slot, b.patient_name,
              b.patient_phone, b.address, b.amount, b.status, b.created_at,
              l.name AS lab_name, l.address AS lab_address,
              t.name AS test_name, t.slug AS test_slug
       FROM bookings b
       JOIN labs l ON l.id = b.lab_id
       JOIN tests t ON t.id = b.test_id
       WHERE b.user_id = $1
       ORDER BY b.created_at DESC`,
      [req.user!.id]
    );
    res.json({ bookings: result.rows });
  } catch (error) { next(error); }
});

router.patch('/:id/cancel', async (req, res, next) => {
  try {
    const result = await pool.query(
      `UPDATE bookings SET status = 'cancelled'
       WHERE id = $1 AND user_id = $2 AND status = 'confirmed'
       RETURNING id, status`,
      [req.params.id, req.user!.id]
    );
    if (!result.rows[0]) return res.status(404).json({ message: 'Active booking not found.' });
    res.json({ message: 'Booking cancelled.', booking: result.rows[0] });
  } catch (error) { next(error); }
});

export default router;
