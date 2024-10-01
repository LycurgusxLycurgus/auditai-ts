// src/routes/processDocuments.ts
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { extractData } from '../modules/extraction.js';
import { classifyDocumentType } from '../modules/classification.js';
import * as DatabaseService from '../services/database.js';

// Extend FastifyInstance to include the database property
declare module 'fastify' {
  interface FastifyInstance {
    database: typeof DatabaseService;
  }
}

interface ProcessRequestBody {
  files: Array<{ path: string; title: string }>;
}

export default async function (fastify: FastifyInstance) {
  fastify.post('/process-documents', async (request: FastifyRequest, reply: FastifyReply) => {
    const body = request.body as ProcessRequestBody;

    // Create a new activation
    const activationId = await fastify.database.createActivation();

    for (const file of body.files) {
      const { documentId, ocrNeeded } = await extractData({
        activationId,
        filePath: file.path,
        title: file.title,
      });

      // Read the document content (implement reading logic)
      const documentContent = '...'; // Replace with actual file reading

      await classifyDocumentType({
        activationId,
        documentId,
        documentContent,
        title: file.title,
      });

      // Continue with other modules as needed
    }

    reply.send({ status: 'Processing initiated', activationId });
  });
}
