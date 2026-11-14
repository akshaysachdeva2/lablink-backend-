
import { Router } from 'express';
import multer from 'multer';
import { requireAuth } from '../middleware/auth.js';
import { summarizeUploadedReport } from '../services/gemini.js';

const router = Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024
  },
  fileFilter: (_req, file, callback) => {
    const allowedTypes = [
      'application/pdf',
      'image/jpeg',
      'image/png'
    ];

    if (!allowedTypes.includes(file.mimetype)) {
      return callback(
        new Error('Only PDF, JPG and PNG reports are allowed.')
      );
    }

    callback(null, true);
  }
});

router.post(
  '/summarize',
  requireAuth,
  upload.single('report'),
  async (req, res, next) => {
    try {
      if (req.body.consent !== 'true') {
        return res.status(400).json({
          message: 'Consent is required before analyzing a medical report.'
        });
      }

      if (!req.file) {
        return res.status(400).json({
          message: 'Please upload a medical report.'
        });
      }

      const summary = await summarizeUploadedReport(
        req.file.buffer,
        req.file.mimetype
      );

      res.json({
        success: true,
        summary
      });
    } catch (error) {
      next(error);
    }
  }
);

export default router;
