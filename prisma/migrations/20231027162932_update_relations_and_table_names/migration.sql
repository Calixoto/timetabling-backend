/*
  Warnings:

  - You are about to drop the column `userId` on the `coordinators` table. All the data in the column will be lost.
  - You are about to drop the column `classroomId` on the `courses` table. All the data in the column will be lost.
  - You are about to drop the column `courseId` on the `teachers` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `teachers` table. All the data in the column will be lost.
  - You are about to drop the `TeacherSchedulePreference` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `classroom` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[user_id]` on the table `coordinators` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[user_id]` on the table `teachers` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `user_id` to the `coordinators` table without a default value. This is not possible if the table is not empty.
  - Added the required column `class_room_id` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `teacher_id` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `user_id` to the `teachers` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "TeacherSchedulePreference" DROP CONSTRAINT "TeacherSchedulePreference_teacherId_fkey";

-- DropForeignKey
ALTER TABLE "coordinators" DROP CONSTRAINT "coordinators_userId_fkey";

-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_classroomId_fkey";

-- DropForeignKey
ALTER TABLE "teachers" DROP CONSTRAINT "teachers_courseId_fkey";

-- DropForeignKey
ALTER TABLE "teachers" DROP CONSTRAINT "teachers_userId_fkey";

-- AlterTable
ALTER TABLE "coordinators" DROP COLUMN "userId",
ADD COLUMN     "user_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "courses" DROP COLUMN "classroomId",
ADD COLUMN     "class_room_id" TEXT NOT NULL,
ADD COLUMN     "teacher_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "teachers" DROP COLUMN "courseId",
DROP COLUMN "userId",
ADD COLUMN     "schedulePreference" TEXT[],
ADD COLUMN     "user_id" TEXT NOT NULL;

-- DropTable
DROP TABLE "TeacherSchedulePreference";

-- DropTable
DROP TABLE "classroom";

-- CreateTable
CREATE TABLE "class_room" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "location" TEXT NOT NULL,

    CONSTRAINT "class_room_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "coordinators_user_id_key" ON "coordinators"("user_id");

-- CreateIndex
CREATE INDEX "courses_teacher_id_class_room_id_idx" ON "courses"("teacher_id", "class_room_id");

-- CreateIndex
CREATE UNIQUE INDEX "teachers_user_id_key" ON "teachers"("user_id");

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "teachers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coordinators" ADD CONSTRAINT "coordinators_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_class_room_id_fkey" FOREIGN KEY ("class_room_id") REFERENCES "class_room"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
