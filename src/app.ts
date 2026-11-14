import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import { env } from './config/env.js';

import authRoutes from './routes/auth.routes.js';
import catalogRoutes from './routes/catalog.routes.js';
import bookingRoutes from './routes/bookings.routes.js';
import aiRoutes from './routes/ai.routes.js';
import reportsRoutes from './routes/reports.routes.js';

import { errorHandler, notFound } from './middleware/errors.js';

export const app = express();

// Security and cross-origin configuration
app.use(
  cors({
    origin: [
      'http://localhost:5173',
      new URL(env.FRONTEND_URL).origin
    ],
    credentials: true
  })
);

app.use(helmet());

// Request parsing
app.use(express.json({ limit: '1mb' }));

// Global API rate limiting
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 300,
    standardHeaders: 'draft-7',
    legacyHeaders: false
  })
);

// Health check
app.get('/api/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'LabLink API'
  });
});

// Existing API routes
app.use('/api/auth', authRoutes);
app.use('/api', catalogRoutes);
app.use('/api/bookings', bookingRoutes);

// AI and report routes
app.use('/api/ai', aiRoutes);
app.use('/api/reports', reportsRoutes);

// Error handling must remain last
app.use(notFound);
app.use(errorHandler);
