// src/index.ts
import Fastify from 'fastify';
import { ZodTypeProvider, serializerCompiler, validatorCompiler } from 'fastify-type-provider-zod';
import dotenv from 'dotenv';
import { z } from 'zod';
import processDocumentsRoute from './routes/processDocuments.js';
import prisma from './services/prisma';
import * as database from './services/database.js';

dotenv.config();

const envSchema = z.object({
  PORT: z.string().regex(/^\d+$/).transform(Number),
  LOG_LEVEL: z.string().optional().default('info'),
  DATABASE_URL: z.string().url(),
  SUPABASE_URL: z.string().url(),
  SUPABASE_KEY: z.string(),
});

const parsedEnv = envSchema.safeParse(process.env);

if (!parsedEnv.success) {
  console.error('❌ Invalid environment variables:', parsedEnv.error.format());
  process.exit(1);
}

const { PORT, LOG_LEVEL } = parsedEnv.data;

const server = Fastify({
  logger: {
    level: LOG_LEVEL,
  },
})
  .setValidatorCompiler(validatorCompiler)
  .setSerializerCompiler(serializerCompiler)
  .withTypeProvider<ZodTypeProvider>();

// Attach database services to Fastify instance
server.decorate('database', database);

// Register routes
server.register(processDocumentsRoute);

// Example route
server.get('/hello', {
  schema: {
    response: {
      200: z.object({
        message: z.string(),
      }),
    },
  },
}, async (request, reply) => {
  return { message: 'Hello, World!' };
});

const start = async () => {
  try {
    await server.listen({ port: PORT, host: '0.0.0.0' });
    server.log.info(`Server is running at http://localhost:${PORT}`);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

start();
