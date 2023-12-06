/*
  Warnings:

  - You are about to drop the column `schedule` on the `courses` table. All the data in the column will be lost.
  - You are about to drop the column `scheduledClassId` on the `courses` table. All the data in the column will be lost.
  - Added the required column `schedule_id` to the `courses` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_scheduledClassId_fkey";

-- DropIndex
DROP INDEX "courses_scheduledClassId_idx";

-- AlterTable
ALTER TABLE "courses" DROP COLUMN "schedule",
DROP COLUMN "scheduledClassId",
ADD COLUMN     "schedule_id" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "courses_schedule_id_idx" ON "courses"("schedule_id");

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "schedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
