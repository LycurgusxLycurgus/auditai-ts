// src/services/database.ts
import prisma from './prisma.js';
import { v4 as uuidv4 } from 'uuid';

export const createActivation = async () => {
  const activationId = uuidv4();
  // Optionally, save activation details in a separate table
  return activationId;
};

export const createDocumentRecord = async (data: {
  activationId: string;
  title: string;
  ocr: boolean;
  downloadDate: Date;
  movedFromEndpoint: boolean;
  endpointLocation: string;
}) => {
  return await prisma.index.create({
    data: {
      documentId: uuidv4(),
      activationId: data.activationId,
      title: data.title,
      ocr: data.ocr,
      downloadDate: data.downloadDate,
      movedFromEndpoint: data.movedFromEndpoint,
      endpointLocation: data.endpointLocation,
      classification: '',
    },
  });
};

// Add additional functions for other tables here

// Example: Update classification
export const updateClassification = async (documentId: string, classification: string) => {
  const indexRecord = await prisma.index.findFirst({
    where: { documentId },
  });

  if (!indexRecord) {
    throw new Error(`No Index record found for documentId: ${documentId}`);
  }

  return await prisma.index.update({
    where: { id: indexRecord.id },
    data: { classification },
  });
};
