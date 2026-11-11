import { Router } from 'express';
import { pool } from '../db/pool.js';

const router = Router();

router.get('/tests', async (req, res, next) => {
  try {
    const search = String(req.query.search ?? '').trim();
    const category = String(req.query.category ?? '').trim();
    const result = await pool.query(
      `SELECT t.id, t.name, t.slug, t.category, t.description, t.preparation, t.report_time,
              MIN(p.price)::numeric AS starting_price, COUNT(DISTINCT p.lab_id)::int AS lab_count
       FROM tests t
       LEFT JOIN lab_test_prices p ON p.test_id = t.id AND p.available = TRUE
       WHERE t.is_active = TRUE
         AND ($1 = '' OR t.name ILIKE '%' || $1 || '%' OR t.category ILIKE '%' || $1 || '%')
         AND ($2 = '' OR t.category ILIKE $2)
       GROUP BY t.id
       ORDER BY t.name`,
      [search, category]
    );
    res.json({ tests: result.rows });
  } catch (error) { next(error); }
});

router.get('/tests/:slug', async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT t.id, t.name, t.slug, t.category, t.description, t.preparation, t.report_time
       FROM tests t WHERE t.slug = $1 AND t.is_active = TRUE`,
      [req.params.slug]
    );
    if (!result.rows[0]) return res.status(404).json({ message: 'Test not found.' });
    res.json({ test: result.rows[0] });
  } catch (error) { next(error); }
});

router.get('/tests/:slug/labs', async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT l.id, l.name, l.description, l.address, l.city, l.rating, l.review_count,
              l.home_collection, p.price, p.original_price, p.available
       FROM tests t
       JOIN lab_test_prices p ON p.test_id = t.id
       JOIN labs l ON l.id = p.lab_id
       WHERE t.slug = $1 AND l.is_active = TRUE
       ORDER BY p.price ASC`,
      [req.params.slug]
    );
    res.json({ labs: result.rows });
  } catch (error) { next(error); }
});

router.get('/labs', async (_req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT l.id, l.name, l.description, l.address, l.city, l.rating, l.review_count,
              l.home_collection, COUNT(DISTINCT p.test_id)::int AS test_count
       FROM labs l
       LEFT JOIN lab_test_prices p ON p.lab_id = l.id AND p.available = TRUE
       WHERE l.is_active = TRUE
       GROUP BY l.id
       ORDER BY l.rating DESC, l.name`
    );
    res.json({ labs: result.rows });
  } catch (error) { next(error); }
});

export default router;
