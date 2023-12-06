/*
  Warnings:

  - You are about to drop the `scheduled_classes` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "courses" DROP CONSTRAINT "courses_class_room_id_fkey";

-- DropTable
DROP TABLE "scheduled_classes";

-- CreateTable
CREATE TABLE "schedule" (
    "id" TEXT NOT NULL,
    "weekday" TEXT NOT NULL,
    "schedule" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "schedule_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_class_room_id_fkey" FOREIGN KEY ("class_room_id") REFERENCES "schedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
