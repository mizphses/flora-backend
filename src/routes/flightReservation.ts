import { Hono } from 'hono';
import { FlightReservationService } from '../services/flightReservation.service';

const flightReservation = new Hono<{ Bindings: CloudflareBindings }>();

// 機能的には、フライトの検索、航空券の予約、座席指定を持たせたい

// フライト全般の検索
flightReservation.post('/search', async (c) => {
  const { departureAirport, arrivalAirport, departureDate } = await c.req.json();
  const flightReservationService = new FlightReservationService(c.env.DB);
  const flights = await flightReservationService.searchFlights(departureAirport, arrivalAirport, departureDate);
  return c.json(flights);
});

// flightReservation.post('/issueTicket', async (c) => {
//   const { flightIds } = await c.req.json(); // 複数レグの場合も考慮
//   const flightReservationService = new FlightReservationService(c.env.DB);
//   const tickets = await flightReservationService.issueTickets(flightIds);
//   return c.json(tickets);
// });

// // 座席指定
// flightReservation.post('/assignSeat', async (c) => {
//   const { flightId, seatNumber } = await c.req.json();
//   const flightReservationService = new FlightReservationService(c.env.DB);
//   const reservation = await flightReservationService.assignSeat(flightId, seatNumber);
//   return c.json(reservation);
// });

// // PNR照会
// flightReservation.post('/getTicketInfo', async (c) => {
//   const { pnrId } = await c.req.json();
//   const flightReservationService = new FlightReservationService(c.env.DB);
//   const pnr = await flightReservationService.getTicketInfo(pnrId);
//   return c.json(pnr);
// });

// // 同一PNRのフライト変更
// flightReservation.post('/changeFlight', async (c) => {
//   const { pnrId, newFlightId } = await c.req.json();
//   const flightReservationService = new FlightReservationService(c.env.DB);
//   const reservation = await flightReservationService.changeFlight(pnrId, newFlightId);
//   return c.json(reservation);
// });

// // 特定PNRから一部フライトを削除
// flightReservation.post('/removeFlight', async (c) => {
//   const { pnrId, flightId } = await c.req.json();
//   const flightReservationService = new FlightReservationService(c.env.DB);
//   const reservation = await flightReservationService.removeFlight(pnrId, flightId);
//   return c.json(reservation);
// });

export default flightReservation;
