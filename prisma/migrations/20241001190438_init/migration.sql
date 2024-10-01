-- CreateTable
CREATE TABLE "index_table" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "ocr" BOOLEAN NOT NULL,
    "downloadDate" TIMESTAMP(3) NOT NULL,
    "movedFromEndpoint" BOOLEAN NOT NULL,
    "endpointLocation" TEXT NOT NULL,
    "classification" TEXT NOT NULL,

    CONSTRAINT "index_table_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contratos_info_general" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "mitigationProgram" TEXT NOT NULL,
    "json" JSONB NOT NULL,
    "company" TEXT NOT NULL,
    "companyIdentifier" TEXT NOT NULL,
    "thirdPartyIdentifier" TEXT NOT NULL,
    "thirdPartyName" TEXT NOT NULL,
    "contractType" TEXT NOT NULL,
    "serviceType" TEXT NOT NULL,
    "object" TEXT NOT NULL,
    "currency" TEXT NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "validity" INTEGER NOT NULL,

    CONSTRAINT "contratos_info_general_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contratos_clausulas" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "json" JSONB NOT NULL,

    CONSTRAINT "contratos_clausulas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contrato_amparos" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "json" JSONB NOT NULL,

    CONSTRAINT "contrato_amparos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otrosi_info_general" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "otrosiNumber" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "thirdPartyIdentifier" TEXT NOT NULL,
    "thirdPartyName" TEXT NOT NULL,
    "signatureDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "otrosi_info_general_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otrosi_modificaciones" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "otrosiNumber" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "json" JSONB NOT NULL,

    CONSTRAINT "otrosi_modificaciones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "poliza_info_general" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "otrosiNumber" TEXT NOT NULL,
    "policyNumber" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "json" JSONB NOT NULL,
    "policyHolder" TEXT NOT NULL,
    "beneficiary" TEXT NOT NULL,
    "policyObject" TEXT NOT NULL,
    "totalPayment" DOUBLE PRECISION NOT NULL,
    "totalInsured" DOUBLE PRECISION NOT NULL,
    "paymentDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "poliza_info_general_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "poliza_amparos" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "otrosiNumber" TEXT NOT NULL,
    "policyNumber" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "json" JSONB NOT NULL,

    CONSTRAINT "poliza_amparos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tabla_madre" (
    "id" SERIAL NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "contratosInfoGeneralId" INTEGER NOT NULL,
    "contratosClausulasId" INTEGER NOT NULL,
    "contratoAmparosId" INTEGER NOT NULL,
    "otrosiInfoGeneralId" INTEGER NOT NULL,
    "otrosiModificacionesId" INTEGER NOT NULL,
    "polizaInfoGeneralId" INTEGER NOT NULL,
    "polizaAmparosId" INTEGER NOT NULL,
    "done" BOOLEAN NOT NULL DEFAULT false,
    "activationId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tabla_madre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documentos_generados" (
    "id" SERIAL NOT NULL,
    "documentId" TEXT NOT NULL,
    "activationId" TEXT NOT NULL,
    "contractConsecutive" TEXT NOT NULL,
    "documentUrl" TEXT NOT NULL,
    "queryUsed" TEXT NOT NULL,
    "templateUsed" TEXT NOT NULL,

    CONSTRAINT "documentos_generados_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documentos_enviados" (
    "id" SERIAL NOT NULL,
    "sentDocumentId" TEXT NOT NULL,
    "incorporatedDocumentIds" TEXT[],
    "activationId" TEXT NOT NULL,
    "documentUrl" TEXT NOT NULL,

    CONSTRAINT "documentos_enviados_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_contratosInfoGeneralId_key" ON "tabla_madre"("contratosInfoGeneralId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_contratosClausulasId_key" ON "tabla_madre"("contratosClausulasId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_contratoAmparosId_key" ON "tabla_madre"("contratoAmparosId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_otrosiInfoGeneralId_key" ON "tabla_madre"("otrosiInfoGeneralId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_otrosiModificacionesId_key" ON "tabla_madre"("otrosiModificacionesId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_polizaInfoGeneralId_key" ON "tabla_madre"("polizaInfoGeneralId");

-- CreateIndex
CREATE UNIQUE INDEX "tabla_madre_polizaAmparosId_key" ON "tabla_madre"("polizaAmparosId");

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_contratosInfoGeneralId_fkey" FOREIGN KEY ("contratosInfoGeneralId") REFERENCES "contratos_info_general"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_contratosClausulasId_fkey" FOREIGN KEY ("contratosClausulasId") REFERENCES "contratos_clausulas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_contratoAmparosId_fkey" FOREIGN KEY ("contratoAmparosId") REFERENCES "contrato_amparos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_otrosiInfoGeneralId_fkey" FOREIGN KEY ("otrosiInfoGeneralId") REFERENCES "otrosi_info_general"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_otrosiModificacionesId_fkey" FOREIGN KEY ("otrosiModificacionesId") REFERENCES "otrosi_modificaciones"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_polizaInfoGeneralId_fkey" FOREIGN KEY ("polizaInfoGeneralId") REFERENCES "poliza_info_general"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tabla_madre" ADD CONSTRAINT "tabla_madre_polizaAmparosId_fkey" FOREIGN KEY ("polizaAmparosId") REFERENCES "poliza_amparos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
