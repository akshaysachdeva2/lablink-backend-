
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import { env } from './config/env.js';
import authRoutes from './routes/auth.routes.js';
import catalogRoutes from './routes/catalog.routes.js';
import bookingRoutes from './routes/bookings.routes.js';
import { errorHandler, notFound } from './middleware/errors.js';

export const app = express();

// CORS configuration: allow local development and deployed frontend
app.use(cors({
  origin: [
    'http://localhost:5173',
    'https://lablink-frontend-lime.vercel.app'
  ],
  credentials: true
}));

app.use(helmet());
app.use(express.json({ limit: '1mb' }));

app.use(rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 300,
  standardHeaders: 'draft-7',
  legacyHeaders: false
}));

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', service: 'LabLink API' });
});

// API routes
app.use('/api/auth', authRoutes);
app.use('/api', catalogRoutes);
app.use('/api/bookings', bookingRoutes);

// Error handling
app.use(notFound);
app.use(errorHandler);
