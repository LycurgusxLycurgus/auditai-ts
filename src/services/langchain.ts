// src/services/langchain.ts

import { ChatOpenAI } from "@langchain/openai";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { StringOutputParser } from "@langchain/core/output_parsers";
import { AIMessage, HumanMessage, SystemMessage } from "@langchain/core/messages";

/**
 * Classifies the document type based on the provided text snippet.
 * 
 * @param snippet - The text snippet extracted from the document.
 * @returns The classification result as a string.
 */
export const classifyDocument = async (snippet: string): Promise<string> => {
  // Define the prompt template with system and human messages
  const promptTemplate = ChatPromptTemplate.fromMessages([
    new SystemMessage("Classify the document type based on the following text:"),
    new HumanMessage(snippet),
  ]);

  // Initialize the language model with desired configurations
  const model = new ChatOpenAI({
    model: "gpt-4o-mini",
    temperature: 0.0, // Adjust as needed
  });

  // Initialize the output parser to extract plain text from the AI response
  const parser = new StringOutputParser();

  // Create the chain by piping the prompt through the model and parser
  const chain = promptTemplate.pipe(model).pipe(parser);

  // Invoke the chain to get the classification result
  const classification = await chain.invoke({});

  return classification;
};
