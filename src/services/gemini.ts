
import { GoogleGenAI } from '@google/genai';
import { env } from '../config/env.js';

function getGeminiClient(): GoogleGenAI {
  const apiKey = env.GEMINI_API_KEY;

  if (!apiKey) {
    throw new Error('AI report summaries are not configured. Please add GEMINI_API_KEY to the backend environment.');
  }

  return new GoogleGenAI({ apiKey });
}

export async function generateAIResponse(prompt: string): Promise<string> {
  const response = await getGeminiClient().models.generateContent({
    model: 'gemini-3.1-flash-lite',
    contents: prompt,
    config: {
      maxOutputTokens: 2000
    }
  });

  const result = response.text;

  if (!result) {
    throw new Error('Gemini returned an empty response.');
  }

  return result;
}

export async function summarizeMedicalReport(
  reportText: string
): Promise<string> {
  if (!reportText.trim()) {
    throw new Error('Medical report text is empty.');
  }

  const prompt = `
You are LabLink's medical report explanation assistant.

Explain this medical report in simple language using these sections:

1. General overview
2. Normal results
3. Out-of-range results
4. Simple explanations
5. Questions to ask a doctor

Rules:
- Never invent missing values or reference ranges.
- Do not diagnose diseases or prescribe medication.
- Use the laboratory's reference ranges.
- Recommend professional medical review.

Medical report:
${reportText}
`;

  return generateAIResponse(prompt);
}

export async function summarizeUploadedReport(
  fileBuffer: Buffer,
  mimeType: string
): Promise<string> {
  const allowedTypes = [
    'application/pdf',
    'image/jpeg',
    'image/png'
  ];

  if (!allowedTypes.includes(mimeType)) {
    throw new Error('Unsupported report file type.');
  }

  const base64Data = fileBuffer.toString('base64');

  const response = await getGeminiClient().models.generateContent({
    model: 'gemini-3.1-flash-lite',
    contents: [
      {
        inlineData: {
          mimeType,
          data: base64Data
        }
      },
      {
        text: `You are LabLink's medical report explanation assistant.

Analyze this uploaded medical report.

Use these sections:
1. General overview
2. Normal results
3. Out-of-range results
4. Simple explanations
5. Questions to ask a doctor

Never invent missing values or reference ranges.
Do not diagnose diseases or prescribe medication.
Use the reference ranges printed in the report.
If the image or document is unclear, say so.
Recommend professional medical review.`
      }
    ],
    config: {
      maxOutputTokens: 2000
    }
  });

  const result = response.text;

  if (!result) {
    throw new Error('Gemini returned an empty report summary.');
  }

  return result;
}
