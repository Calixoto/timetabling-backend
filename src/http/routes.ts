import { prisma } from "@/lib/prisma";
import axios from "axios";
import { FastifyInstance } from "fastify";
import { authenticate } from "./controllers/authenticate";
import { profile } from "./controllers/profile";
import { refresh } from "./controllers/refresh";
import { register } from "./controllers/register";
import { verifyJWT } from "./middlewares/verify-jwt";

export interface ScheduledClass {
    weekday: string;
    schedule: string;
    id: string;
    courses: Courses[];
  }

export interface ScheduleUpdated {
    data: {
        weekday: string;
    schedule: string;
    id: string;
    courses: Courses[];
    }[]
  }
  
export interface Courses {
    semester: number;
    class_id: string;
    class_name: string;
    room: string;
    room_space: number;
    schedule: string;
    schedule_id: string
  }

  type OrderSchedule = "M12" |
  "M34" |
  "M56" |
  "T12" |
  "T34" |
  "T56" |
  "N12" |
  "N34"

  type orderWeekday = "SEG" | 
  "TER" | 
  "QUA" | 
  "QUI" | 
  "SEX" | 
  "SAB"

export async function appRoutes(app:FastifyInstance) {
    app.post("/users", register);
    app.post("/sessions", authenticate);

    app.patch("/token/refresh", refresh);

    app.post("/schedule", async (request, reply) => {
        try {
            await prisma.course.deleteMany();
            await prisma.schedule.deleteMany();
     
            const {data} = await axios.get("http://localhost:8000/schedule");
     
            await Promise.all(data.map(async (scheduledClass:ScheduledClass) => {
                const savedScheduledClass = await prisma.schedule.create({
                    data: {
                        weekday: scheduledClass.weekday,
                        schedule: scheduledClass.schedule,
                       
                        courses: {
                            create: scheduledClass.courses.map((course) => ({
                                semester: course.semester,
                                class_id: course.class_id,
                                class_name: course.class_name,
                                room: course.room,
                                room_space: course.room_space,
                            }))
                        } 
                    },
                    include: {
                        courses: true
                    }
                });
                console.log(savedScheduledClass);
            }));
            return data;
        } catch (error) {
            console.error(error);
            reply.code(500).send({ error });
        }
    });
     

    app.get("/schedule", async (request, reply) => {
        const  schedule_order = {
            "M12": 0,
            "M34": 1,
            "M56": 2,
            "T12": 3,
            "T34": 4,
            "T56": 5,
            "N12": 6,
            "N34": 7
        };
        const weekday_order = {
            "SEG": 0,
            "TER": 1,
            "QUA": 2,
            "QUI": 3,
            "SEX": 4,
            "SAB": 5
        };
        const schedules = await prisma.schedule.findMany({
            include: {
                courses: true
            },
            orderBy: {
                weekday: "asc"
            }
        });

        reply.send(schedules.sort((a, b) => weekday_order[a.weekday as orderWeekday] - weekday_order[b.weekday as orderWeekday]).sort((a, b) => schedule_order[a.schedule as OrderSchedule] - schedule_order[b.schedule as OrderSchedule]));
    });

    app.put("/schedule/update", async (request, reply) => {
        const {data} = request.body as ScheduleUpdated;
       
        try {
            await prisma.course.deleteMany();
            await prisma.schedule.deleteMany();
     
            await Promise.all(data.map(async (scheduledClass:ScheduledClass) => {
                const savedScheduledClass = await prisma.schedule.create({
                    data: {
                        weekday: scheduledClass.weekday,
                        schedule: scheduledClass.schedule,
                       
                        courses: {
                            create: scheduledClass.courses.map((course) => ({
                                semester: course.semester,
                                class_id: course.class_id,
                                class_name: course.class_name,
                                room: course.room,
                                room_space: course.room_space,
                            }))
                        } 
                    },
                    include: {
                        courses: true
                    }
                });
                console.log(savedScheduledClass);
            }));
            return data;
        } catch (error) {
            console.error(error);
            reply.code(500).send({ error });
        }
    });
    // Authenticated
    app.get("/me", {onRequest: [verifyJWT]} ,profile);
}