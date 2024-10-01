// src/modules/extraction.ts
import { performOCR } from './utils/ocr.js';
import { generateUUID } from './utils/uuid.js';
import prisma from '../services/prisma.js';
import fs from 'fs/promises';
import path from 'path';

interface ExtractionData {
  activationId: string;
  filePath: string;
  title: string;
}

export const extractData = async ({ activationId, filePath, title }: ExtractionData) => {
  // Assign unique ID to the file
  const documentId = generateUUID();

  // Check if OCR is needed (example condition)
  let ocrNeeded = false;
  const stats = await fs.stat(filePath);
  if (stats.size === 0) {
    ocrNeeded = true;
    const ocrText = await performOCR(filePath);
    // Handle OCR text as needed
  }

  // Move file from 'documentos' to 'documentos_descargados'
  const destination = path.join('documentos_descargados', path.basename(filePath));
  await fs.rename(filePath, destination);

  // Save record in Index table
  await prisma.index.create({
    data: {
      documentId,
      activationId,
      title,
      ocr: ocrNeeded,
      downloadDate: new Date(),
      movedFromEndpoint: true,
      endpointLocation: destination,
      classification: '', // To be updated in the next module
    },
  });

  return { documentId, ocrNeeded };
};
