// src/modules/classification.ts
import { generateUUID } from './utils/uuid.js';
import prisma from '../services/prisma.js';
import { classifyDocument } from '../services/langchain.js'; // Assume a LangChain service is set up

interface ClassificationData {
  activationId: string;
  documentId: string;
  documentContent: string;
  title: string;
}

export const classifyDocumentType = async ({
  activationId,
  documentId,
  documentContent,
  title,
}: ClassificationData) => {
  // Send first 300 characters to LangChain classifier
  const snippet = documentContent.substring(0, 300);
  const classification = await classifyDocument(snippet);

  // Find the Index record by documentId
  const indexRecord = await prisma.index.findFirst({
    where: { documentId },
  });

  if (!indexRecord) {
    throw new Error(`No Index record found for documentId: ${documentId}`);
  }

  // Update classification using the id
  await prisma.index.update({
    where: { id: indexRecord.id },
    data: { classification },
  });

  // Conditional routing based on classification
  if (classification === 'Contract') {
    // Proceed to Contract Pathing
    // Implement routing logic
  } else {
    // Handle other document types
    // Implement routing logic
  }

  // Save additional data as needed
};
