import { PrismaD1 } from '@prisma/adapter-d1';
import { PrismaClient } from '../generated/prisma/client';

export class FlightReservationService {
  private prisma: PrismaClient;

  constructor(db: D1Database) {
    const adapter = new PrismaD1(db);
    this.prisma = new PrismaClient({ adapter });
  }

  async searchFlights(departureAirport: string, arrivalAirport: string, departureDate: string) {
    const flights = await this.prisma.operationalFlight.findMany({
      where: {
        departureAirport: {
          locationCode: departureAirport,
        },
        arrivalAirport: {
          locationCode: arrivalAirport,
        },
        scheduledDepartureDateTime: {
          gte: new Date(departureDate),
          lte: new Date(departureDate),
        },
      },
    });
    return flights;
  }
}
