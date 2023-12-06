/*
  Warnings:

  - You are about to drop the column `class_room_id` on the `courses` table. All the data in the column will be lost.
  - Added the required column `scheduledClassId` to the `courses` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_class_room_id_fkey";

-- DropIndex
DROP INDEX "courses_class_room_id_idx";

-- AlterTable
ALTER TABLE "courses" DROP COLUMN "class_room_id",
ADD COLUMN     "scheduledClassId" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "courses_scheduledClassId_idx" ON "courses"("scheduledClassId");

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_scheduledClassId_fkey" FOREIGN KEY ("scheduledClassId") REFERENCES "schedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
