-- CreateTable
CREATE TABLE "AircraftType" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "typeCode" TEXT NOT NULL,
    "typeName" TEXT NOT NULL,
    "manufacturer" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Aircraft" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "registrationNumber" TEXT NOT NULL,
    "aircraftTypeId" TEXT NOT NULL,
    "airlineOwnerId" TEXT,
    "seatLayoutTemplateId" TEXT,
    "status" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Aircraft_aircraftTypeId_fkey" FOREIGN KEY ("aircraftTypeId") REFERENCES "AircraftType" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Aircraft_airlineOwnerId_fkey" FOREIGN KEY ("airlineOwnerId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Aircraft_seatLayoutTemplateId_fkey" FOREIGN KEY ("seatLayoutTemplateId") REFERENCES "SeatLayoutTemplate" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SeatLayoutTemplate" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "aircraftTypeId" TEXT NOT NULL,
    "description" TEXT,
    "totalSeats" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "SeatLayoutTemplate_aircraftTypeId_fkey" FOREIGN KEY ("aircraftTypeId") REFERENCES "AircraftType" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SeatDefinition" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "seatLayoutTemplateId" TEXT NOT NULL,
    "seatNumber" TEXT NOT NULL,
    "cabinClass" TEXT NOT NULL,
    "seatCharacteristic" TEXT,
    "xPosition" INTEGER,
    "yPosition" INTEGER,
    "features" JSONB,
    "isReservable" BOOLEAN NOT NULL DEFAULT true,
    "remarks" TEXT,
    CONSTRAINT "SeatDefinition_seatLayoutTemplateId_fkey" FOREIGN KEY ("seatLayoutTemplateId") REFERENCES "SeatLayoutTemplate" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "FlightSchedule" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "flightNumber" TEXT NOT NULL,
    "marketingAirlineId" TEXT NOT NULL,
    "operatingAirlineId" TEXT,
    "departureAirportId" TEXT NOT NULL,
    "arrivalAirportId" TEXT NOT NULL,
    "standardDepartureTime" TEXT NOT NULL,
    "standardArrivalTime" TEXT NOT NULL,
    "durationMinutes" INTEGER,
    "daysOfWeek" JSONB NOT NULL,
    "defaultAircraftTypeId" TEXT,
    "effectiveStartDate" DATETIME NOT NULL,
    "effectiveEndDate" DATETIME,
    "remarks" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "FlightSchedule_marketingAirlineId_fkey" FOREIGN KEY ("marketingAirlineId") REFERENCES "Company" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "FlightSchedule_operatingAirlineId_fkey" FOREIGN KEY ("operatingAirlineId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightSchedule_departureAirportId_fkey" FOREIGN KEY ("departureAirportId") REFERENCES "AirportInfo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "FlightSchedule_arrivalAirportId_fkey" FOREIGN KEY ("arrivalAirportId") REFERENCES "AirportInfo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "FlightSchedule_defaultAircraftTypeId_fkey" FOREIGN KEY ("defaultAircraftTypeId") REFERENCES "AircraftType" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "OperationalFlight" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "flightScheduleId" TEXT,
    "flightNumber" TEXT NOT NULL,
    "marketingAirlineId" TEXT NOT NULL,
    "operatingAirlineId" TEXT,
    "departureAirportId" TEXT NOT NULL,
    "arrivalAirportId" TEXT NOT NULL,
    "scheduledDepartureDateTime" DATETIME NOT NULL,
    "scheduledArrivalDateTime" DATETIME NOT NULL,
    "estimatedDepartureDateTime" DATETIME,
    "estimatedArrivalDateTime" DATETIME,
    "actualDepartureDateTime" DATETIME,
    "actualArrivalDateTime" DATETIME,
    "aircraftId" TEXT,
    "aircraftTypeId" TEXT,
    "seatLayoutTemplateId" TEXT,
    "status" TEXT NOT NULL,
    "gate" TEXT,
    "terminal" TEXT,
    "remarks" TEXT,
    "checkInStartTime" DATETIME,
    "checkInEndTime" DATETIME,
    "boardingStartTime" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "OperationalFlight_flightScheduleId_fkey" FOREIGN KEY ("flightScheduleId") REFERENCES "FlightSchedule" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_marketingAirlineId_fkey" FOREIGN KEY ("marketingAirlineId") REFERENCES "Company" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_operatingAirlineId_fkey" FOREIGN KEY ("operatingAirlineId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_departureAirportId_fkey" FOREIGN KEY ("departureAirportId") REFERENCES "AirportInfo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_arrivalAirportId_fkey" FOREIGN KEY ("arrivalAirportId") REFERENCES "AirportInfo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_aircraftId_fkey" FOREIGN KEY ("aircraftId") REFERENCES "Aircraft" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_aircraftTypeId_fkey" FOREIGN KEY ("aircraftTypeId") REFERENCES "AircraftType" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OperationalFlight_seatLayoutTemplateId_fkey" FOREIGN KEY ("seatLayoutTemplateId") REFERENCES "SeatLayoutTemplate" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SeatReservation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pnrId" TEXT NOT NULL,
    "passengerId" TEXT NOT NULL,
    "operationalFlightId" TEXT NOT NULL,
    "aircraftId" TEXT NOT NULL,
    "seatNumber" TEXT NOT NULL,
    "cabinClass" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "reservationDateTime" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUpdatedAt" DATETIME NOT NULL,
    "price" DECIMAL,
    "currency" TEXT,
    "segmentRef" TEXT,
    "remarks" TEXT,
    CONSTRAINT "SeatReservation_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SeatReservation_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SeatReservation_operationalFlightId_fkey" FOREIGN KEY ("operationalFlightId") REFERENCES "OperationalFlight" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SeatReservation_aircraftId_fkey" FOREIGN KEY ("aircraftId") REFERENCES "Aircraft" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_FlightSegment" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "departureDateTime" DATETIME,
    "arrivalDateTime" DATETIME,
    "resBookDesigCode" TEXT,
    "numberInParty" INTEGER,
    "status" TEXT,
    "flightNumber" TEXT,
    "dateChangeNbr" TEXT,
    "departureAirportCode" TEXT,
    "arrivalAirportCode" TEXT,
    "operatingAirlineCode" TEXT,
    "operatingAirlineFlightNumber" TEXT,
    "operatingAirlineResBookDesigCode" TEXT,
    "equipmentAirEquipType" TEXT,
    "equipmentChangeOfGauge" BOOLEAN,
    "marketingAirlineCode" TEXT,
    "pnrId" TEXT,
    "pnrHistoryItemId" TEXT,
    "operationalFlightId" TEXT,
    CONSTRAINT "FlightSegment_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "FlightSegment_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightSegment_operationalFlightId_fkey" FOREIGN KEY ("operationalFlightId") REFERENCES "OperationalFlight" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_FlightSegment" ("arrivalAirportCode", "arrivalDateTime", "dateChangeNbr", "departureAirportCode", "departureDateTime", "equipmentAirEquipType", "equipmentChangeOfGauge", "flightNumber", "id", "marketingAirlineCode", "numberInParty", "operatingAirlineCode", "operatingAirlineFlightNumber", "operatingAirlineResBookDesigCode", "pnrHistoryItemId", "pnrId", "resBookDesigCode", "status") SELECT "arrivalAirportCode", "arrivalDateTime", "dateChangeNbr", "departureAirportCode", "departureDateTime", "equipmentAirEquipType", "equipmentChangeOfGauge", "flightNumber", "id", "marketingAirlineCode", "numberInParty", "operatingAirlineCode", "operatingAirlineFlightNumber", "operatingAirlineResBookDesigCode", "pnrHistoryItemId", "pnrId", "resBookDesigCode", "status" FROM "FlightSegment";
DROP TABLE "FlightSegment";
ALTER TABLE "new_FlightSegment" RENAME TO "FlightSegment";
CREATE UNIQUE INDEX "FlightSegment_pnrHistoryItemId_key" ON "FlightSegment"("pnrHistoryItemId");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "AircraftType_typeCode_key" ON "AircraftType"("typeCode");

-- CreateIndex
CREATE UNIQUE INDEX "Aircraft_registrationNumber_key" ON "Aircraft"("registrationNumber");

-- CreateIndex
CREATE UNIQUE INDEX "SeatDefinition_seatLayoutTemplateId_seatNumber_key" ON "SeatDefinition"("seatLayoutTemplateId", "seatNumber");

-- CreateIndex
CREATE UNIQUE INDEX "FlightSchedule_marketingAirlineId_flightNumber_departureAirportId_effectiveStartDate_key" ON "FlightSchedule"("marketingAirlineId", "flightNumber", "departureAirportId", "effectiveStartDate");

-- CreateIndex
CREATE UNIQUE INDEX "OperationalFlight_marketingAirlineId_flightNumber_scheduledDepartureDateTime_departureAirportId_key" ON "OperationalFlight"("marketingAirlineId", "flightNumber", "scheduledDepartureDateTime", "departureAirportId");

-- CreateIndex
CREATE INDEX "SeatReservation_pnrId_passengerId_idx" ON "SeatReservation"("pnrId", "passengerId");

-- CreateIndex
CREATE INDEX "SeatReservation_operationalFlightId_seatNumber_idx" ON "SeatReservation"("operationalFlightId", "seatNumber");

-- CreateIndex
CREATE UNIQUE INDEX "SeatReservation_operationalFlightId_passengerId_key" ON "SeatReservation"("operationalFlightId", "passengerId");

-- CreateIndex
CREATE UNIQUE INDEX "refreshToken_token_key" ON "refreshToken"("token");
