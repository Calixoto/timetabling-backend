/*
  Warnings:

  - You are about to drop the column `teacher_id` on the `courses` table. All the data in the column will be lost.
  - You are about to drop the `coordinators` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `teachers` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "coordinators" DROP CONSTRAINT "coordinators_user_id_fkey";

-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_teacher_id_fkey";

-- DropForeignKey
ALTER TABLE "teachers" DROP CONSTRAINT "teachers_user_id_fkey";

-- DropIndex
DROP INDEX "courses_teacher_id_class_room_id_idx";

-- AlterTable
ALTER TABLE "courses" DROP COLUMN "teacher_id",
ADD COLUMN     "schedule" TEXT[];

-- DropTable
DROP TABLE "coordinators";

-- DropTable
DROP TABLE "teachers";

-- CreateIndex
CREATE INDEX "courses_class_room_id_idx" ON "courses"("class_room_id");
