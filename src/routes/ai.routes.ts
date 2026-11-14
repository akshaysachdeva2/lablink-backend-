
import { Router } from 'express';
import { generateAIResponse } from '../services/gemini.js';
import { requireAuth } from '../middleware/auth.js';

const router = Router();

router.get('/test', requireAuth, async (_req, res, next) => {
  try {
    const result = await generateAIResponse(
      'Reply with exactly: LabLink Gemini integration is working!'
    );

    res.json({
      success: true,
      message: result
    });
  } catch (error) {
    next(error);
  }
});

export default router;
