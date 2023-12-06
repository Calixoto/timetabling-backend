/*
  Warnings:

  - You are about to drop the column `capacity` on the `courses` table. All the data in the column will be lost.
  - You are about to drop the column `code` on the `courses` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `courses` table. All the data in the column will be lost.
  - Added the required column `class_id` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `class_name` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `room` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `room_space` to the `courses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `semester` to the `courses` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_class_room_id_fkey";

-- AlterTable
ALTER TABLE "courses" DROP COLUMN "capacity",
DROP COLUMN "code",
DROP COLUMN "name",
ADD COLUMN     "class_id" TEXT NOT NULL,
ADD COLUMN     "class_name" TEXT NOT NULL,
ADD COLUMN     "room" TEXT NOT NULL,
ADD COLUMN     "room_space" INTEGER NOT NULL,
ADD COLUMN     "semester" INTEGER NOT NULL,
ALTER COLUMN "schedule" SET NOT NULL,
ALTER COLUMN "schedule" SET DATA TYPE TEXT;

-- CreateTable
CREATE TABLE "scheduled_classes" (
    "id" TEXT NOT NULL,
    "semester" INTEGER NOT NULL,
    "weekday" TEXT NOT NULL,
    "schedule" TEXT NOT NULL,
    "class_id" TEXT NOT NULL,
    "class_name" TEXT NOT NULL,
    "room" TEXT NOT NULL,
    "room_space" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "scheduled_classes_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_class_room_id_fkey" FOREIGN KEY ("class_room_id") REFERENCES "scheduled_classes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
