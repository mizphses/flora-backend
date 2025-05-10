-- CreateTable
CREATE TABLE "CrewIdentity" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "lastName" TEXT,
    "firstName" TEXT,
    "roles" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "PassengerUser" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "password" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "PNRGOVMessage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "echoToken" TEXT,
    "timeStamp" DATETIME,
    "target" TEXT,
    "version" TEXT,
    "transactionIdentifier" TEXT,
    "sequenceNmbr" INTEGER,
    "transactionStatusCode" TEXT,
    "primaryLangID" TEXT,
    "altLangID" TEXT,
    "retransmissionIndicator" BOOLEAN,
    "correlationID" TEXT,
    "schemaVersion" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Originator" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "airlineCode" TEXT NOT NULL,
    "systemCode" TEXT NOT NULL,
    "airlineContactInfo" TEXT,
    "pnrGovMessageId" TEXT NOT NULL,
    CONSTRAINT "Originator_pnrGovMessageId_fkey" FOREIGN KEY ("pnrGovMessageId") REFERENCES "PNRGOVMessage" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "FlightLeg" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "carrierCode" TEXT NOT NULL,
    "flightNumber" TEXT NOT NULL,
    "departureDateTime" DATETIME NOT NULL,
    "arrivalDateTime" DATETIME NOT NULL,
    "dateChangeNbr" TEXT,
    "operationalSuffix" TEXT,
    "departureAirportId" TEXT,
    "arrivalAirportId" TEXT,
    "operatingAirlineId" TEXT,
    "marketingAirlineId" TEXT,
    "pnrGovMessageId" TEXT NOT NULL,
    CONSTRAINT "FlightLeg_departureAirportId_fkey" FOREIGN KEY ("departureAirportId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightLeg_arrivalAirportId_fkey" FOREIGN KEY ("arrivalAirportId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightLeg_operatingAirlineId_fkey" FOREIGN KEY ("operatingAirlineId") REFERENCES "OperatingAirlineInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightLeg_marketingAirlineId_fkey" FOREIGN KEY ("marketingAirlineId") REFERENCES "MarketingAirlineInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "FlightLeg_pnrGovMessageId_fkey" FOREIGN KEY ("pnrGovMessageId") REFERENCES "PNRGOVMessage" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AirportInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "locationCode" TEXT NOT NULL,
    "codeContext" TEXT
);

-- CreateTable
CREATE TABLE "OperatingAirlineInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "companyShortName" TEXT,
    "travelSector" TEXT,
    "code" TEXT NOT NULL,
    "codeContext" TEXT,
    "flightNumber" TEXT,
    "resBookDesigCode" TEXT
);

-- CreateTable
CREATE TABLE "MarketingAirlineInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "companyShortName" TEXT,
    "travelSector" TEXT,
    "code" TEXT NOT NULL,
    "codeContext" TEXT
);

-- CreateTable
CREATE TABLE "EquipmentInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "airEquipType" TEXT NOT NULL,
    "changeOfGauge" BOOLEAN,
    "flightLegId" TEXT NOT NULL,
    CONSTRAINT "EquipmentInfo_flightLegId_fkey" FOREIGN KEY ("flightLegId") REFERENCES "FlightLeg" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PNRsContainer" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "numberOfPnrs" INTEGER NOT NULL,
    "pnrGovMessageId" TEXT NOT NULL,
    CONSTRAINT "PNRsContainer_pnrGovMessageId_fkey" FOREIGN KEY ("pnrGovMessageId") REFERENCES "PNRGOVMessage" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PNR" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "numberOfPassengers" INTEGER NOT NULL,
    "pnrTransDate" DATETIME,
    "pnrCreationDate" DATETIME,
    "lastTktDate" DATETIME,
    "pnrsContainerId" TEXT NOT NULL,
    "unstructuredPnrHistory" TEXT,
    CONSTRAINT "PNR_pnrsContainerId_fkey" FOREIGN KEY ("pnrsContainerId") REFERENCES "PNRsContainer" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "UniqueId" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "url" TEXT,
    "type" TEXT,
    "companyId" TEXT,
    "bookingRefId" TEXT,
    "requestorId" TEXT,
    "pnrHistoryCreditId" TEXT,
    CONSTRAINT "UniqueId_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "companyShortName" TEXT,
    "travelSector" TEXT,
    "code" TEXT NOT NULL,
    "codeContext" TEXT
);

-- CreateTable
CREATE TABLE "BookingRef" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "uniqueIdDetailsId" TEXT NOT NULL,
    "pnrId" TEXT,
    "flightSegmentId" TEXT,
    CONSTRAINT "BookingRef_uniqueIdDetailsId_fkey" FOREIGN KEY ("uniqueIdDetailsId") REFERENCES "UniqueId" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "BookingRef_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "BookingRef_flightSegmentId_fkey" FOREIGN KEY ("flightSegmentId") REFERENCES "FlightSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SSRItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "ssrCode" TEXT NOT NULL,
    "serviceQuantity" INTEGER,
    "status" TEXT,
    "boardPoint" TEXT,
    "offPoint" TEXT,
    "rph" TEXT,
    "surnameRefNumber" TEXT,
    "text" TEXT,
    "airlineId" TEXT,
    "pnrId" TEXT,
    "passengerId" TEXT,
    "flightSegmentId" TEXT,
    "pnrHistoryItemId" TEXT,
    CONSTRAINT "SSRItem_airlineId_fkey" FOREIGN KEY ("airlineId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "SSRItem_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SSRItem_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SSRItem_flightSegmentId_fkey" FOREIGN KEY ("flightSegmentId") REFERENCES "FlightSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SSRItem_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "OSIItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT,
    "text" TEXT,
    "rph" TEXT,
    "surnameRefNumber" TEXT,
    "airlineId" TEXT,
    "pnrId" TEXT,
    "passengerId" TEXT,
    "flightSegmentId" TEXT,
    "pnrHistoryItemId" TEXT,
    CONSTRAINT "OSIItem_airlineId_fkey" FOREIGN KEY ("airlineId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OSIItem_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "OSIItem_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "OSIItem_flightSegmentId_fkey" FOREIGN KEY ("flightSegmentId") REFERENCES "FlightSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "OSIItem_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "POS" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pnrId" TEXT NOT NULL,
    CONSTRAINT "POS_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "POSSource" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "requestorId" TEXT,
    "posId" TEXT NOT NULL,
    CONSTRAINT "POSSource_requestorId_fkey" FOREIGN KEY ("requestorId") REFERENCES "UniqueId" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "POSSource_posId_fkey" FOREIGN KEY ("posId") REFERENCES "POS" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ContactInformation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "formattedInd" BOOLEAN,
    "defaultInd" BOOLEAN,
    "useType" TEXT,
    "rph" TEXT,
    "type" TEXT,
    "phoneNumber" TEXT,
    "emailAddress" TEXT,
    "phoneType" TEXT,
    "poBox" TEXT,
    "streetNmbrSuffix" TEXT,
    "streetDirection" TEXT,
    "ruralRouteNmbr" TEXT,
    "bldgRoom" TEXT,
    "cityName" TEXT,
    "postalCode" TEXT,
    "county" TEXT,
    "stateProvStateCode" TEXT,
    "countryNameCode" TEXT,
    "pnrId" TEXT,
    "passengerId" TEXT,
    CONSTRAINT "ContactInformation_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "ContactInformation_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ContactAddressLine" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "value" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "contactInfoId" TEXT NOT NULL,
    CONSTRAINT "ContactAddressLine_contactInfoId_fkey" FOREIGN KEY ("contactInfoId") REFERENCES "ContactInformation" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PrepaidBag" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "issuerCode" TEXT,
    "serialNumber" TEXT,
    "sequenceCount" INTEGER,
    "baggagePool" TEXT,
    "unitOfMeasureQuantity" REAL,
    "unitOfMeasure" TEXT,
    "unitOfMeasureCode" TEXT,
    "amount" REAL,
    "currencyCode" TEXT,
    "decimalPlaces" INTEGER,
    "bagDestination" TEXT,
    "pnrId" TEXT NOT NULL,
    CONSTRAINT "PrepaidBag_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Passenger" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "rph" TEXT,
    "surnameRefNumber" TEXT,
    "boardingStatus" TEXT,
    "accompaniedByInfantInd" BOOLEAN,
    "givenName" TEXT,
    "surnamePrefix" TEXT,
    "surname" TEXT NOT NULL,
    "pnrId" TEXT NOT NULL,
    "checkInBoardingNumberId" TEXT,
    "pnrHistoryItemId" TEXT,
    CONSTRAINT "Passenger_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Passenger_checkInBoardingNumberId_fkey" FOREIGN KEY ("checkInBoardingNumberId") REFERENCES "BoardingNumberInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Passenger_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PassengerMiddleName" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "value" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "PassengerMiddleName_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PassengerNameTitle" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "value" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "PassengerNameTitle_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CustLoyalty" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "programID" TEXT,
    "membershipID" TEXT,
    "loyalLevel" TEXT,
    "vendorCode" TEXT,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "CustLoyalty_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ExcessBaggage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "issuerCode" TEXT,
    "serialNumber" TEXT,
    "sequenceCount" INTEGER,
    "baggagePool" TEXT,
    "unitOfMeasureQuantity" REAL,
    "unitOfMeasure" TEXT,
    "unitOfMeasureCode" TEXT,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "ExcessBaggage_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "FareInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "ptcCode" TEXT,
    "discountedFareType" TEXT,
    "discountPercent" REAL,
    "countryCode" TEXT,
    "discFareClassType" TEXT,
    "fareBasis" TEXT,
    "inHouseFareType" TEXT,
    "unstructuredFareCalcType" TEXT,
    "unstructuredFareCalcPricingCode" TEXT,
    "unstructuredFareCalcReportingCode" TEXT,
    "unstructuredFareCalcInfo" TEXT,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "FareInfo_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "TicketDocument" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "ticketDocumentNbr" TEXT,
    "type" TEXT,
    "dateOfIssue" DATETIME,
    "ticketLocation" TEXT,
    "primaryDocInd" BOOLEAN,
    "exchangeTktNbrInd" BOOLEAN,
    "reasonForIssuanceCode" TEXT,
    "reasonForIssuanceSubCode" TEXT,
    "description" TEXT,
    "passengerId" TEXT NOT NULL,
    CONSTRAINT "TicketDocument_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "TotalFare" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "amount" REAL NOT NULL,
    "currencyCode" TEXT NOT NULL,
    "decimalPlaces" INTEGER,
    "ticketDocumentId" TEXT NOT NULL,
    CONSTRAINT "TotalFare_ticketDocumentId_fkey" FOREIGN KEY ("ticketDocumentId") REFERENCES "TicketDocument" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PriceInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "date" DATETIME,
    "time" TEXT,
    "isoCountryCode" TEXT,
    "locationCode" TEXT,
    "netReportingCode" TEXT,
    "nonEndorsableInd" BOOLEAN,
    "nonRefundableInd" BOOLEAN,
    "penaltyRestrictionInd" BOOLEAN,
    "ticketDocumentId" TEXT NOT NULL,
    CONSTRAINT "PriceInfo_ticketDocumentId_fkey" FOREIGN KEY ("ticketDocumentId") REFERENCES "TicketDocument" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Tax" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "qualifier" TEXT,
    "isoCountryCode" TEXT,
    "amount" REAL NOT NULL,
    "currencyCode" TEXT NOT NULL,
    "decimalPlaces" INTEGER,
    "taxType" TEXT,
    "filedAmount" REAL,
    "filedCurrencyCode" TEXT,
    "filedTaxType" TEXT,
    "conversionRate" REAL,
    "usage" TEXT,
    "ticketDocumentId" TEXT NOT NULL,
    CONSTRAINT "Tax_ticketDocumentId_fkey" FOREIGN KEY ("ticketDocumentId") REFERENCES "TicketDocument" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PaymentInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "paymentType" TEXT,
    "paymentUse" TEXT,
    "paymentAmount" REAL,
    "vendorCode" TEXT,
    "accountNbr" TEXT,
    "expiryDate" TEXT,
    "cardHolderName" TEXT,
    "ticketDocumentId" TEXT NOT NULL,
    CONSTRAINT "PaymentInfo_ticketDocumentId_fkey" FOREIGN KEY ("ticketDocumentId") REFERENCES "TicketDocument" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Sponsor" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nameAddressPhone" TEXT NOT NULL,
    "paymentInfoId" TEXT NOT NULL,
    CONSTRAINT "Sponsor_paymentInfoId_fkey" FOREIGN KEY ("paymentInfoId") REFERENCES "PaymentInfo" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "DocSSR" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "flightInfoId" TEXT,
    "pnrId" TEXT,
    "passengerId" TEXT,
    CONSTRAINT "DocSSR_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "DocSSR_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "DocFlightInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "docSsrId" TEXT NOT NULL,
    "airlineId" TEXT,
    CONSTRAINT "DocFlightInfo_docSsrId_fkey" FOREIGN KEY ("docSsrId") REFERENCES "DocSSR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "DocFlightInfo_airlineId_fkey" FOREIGN KEY ("airlineId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PnrHistoryCredit" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "originatorId" TEXT,
    "companyId" TEXT,
    "structuredPnrHistoryId" TEXT NOT NULL,
    CONSTRAINT "PnrHistoryCredit_originatorId_fkey" FOREIGN KEY ("originatorId") REFERENCES "UniqueId" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "PnrHistoryCredit_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "PnrHistoryCredit_structuredPnrHistoryId_fkey" FOREIGN KEY ("structuredPnrHistoryId") REFERENCES "StructuredPnrHistory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "FlightSegment" (
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
    CONSTRAINT "FlightSegment_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "FlightSegment_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CheckInInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "agentID" TEXT,
    "time" DATETIME,
    "flightSegmentId" TEXT NOT NULL,
    CONSTRAINT "CheckInInfo_flightSegmentId_fkey" FOREIGN KEY ("flightSegmentId") REFERENCES "FlightSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "BoardingNumberInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "number" TEXT,
    "type" TEXT,
    "rph" TEXT,
    "surnameRefNumber" TEXT,
    "checkInInfoId" TEXT NOT NULL,
    CONSTRAINT "BoardingNumberInfo_checkInInfoId_fkey" FOREIGN KEY ("checkInInfoId") REFERENCES "CheckInInfo" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SeatNumber" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "seatNumberValue" TEXT NOT NULL,
    "cabinClass" TEXT,
    "boardingNumberInfoId" TEXT NOT NULL,
    CONSTRAINT "SeatNumber_boardingNumberInfoId_fkey" FOREIGN KEY ("boardingNumberInfoId") REFERENCES "BoardingNumberInfo" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CheckedBag" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "issuerCode" TEXT,
    "serialNumber" TEXT,
    "sequenceCount" INTEGER,
    "baggagePool" TEXT,
    "unitOfMeasureQuantity" INTEGER,
    "unitOfMeasure" TEXT,
    "unitOfMeasureCode" TEXT,
    "bagDestination" TEXT,
    "boardingNumberInfoId" TEXT NOT NULL,
    CONSTRAINT "CheckedBag_boardingNumberInfoId_fkey" FOREIGN KEY ("boardingNumberInfoId") REFERENCES "BoardingNumberInfo" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SplitPNR" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nbrOfPassengers" INTEGER NOT NULL,
    "vendorCode" TEXT,
    "pnrId" TEXT NOT NULL,
    CONSTRAINT "SplitPNR_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "OtherTravelSegment" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "serviceID" TEXT,
    "startDate" DATETIME,
    "endDate" DATETIME,
    "status" TEXT,
    "quantity" INTEGER,
    "freeText" TEXT,
    "bookingSource" TEXT,
    "startLocationId" TEXT,
    "endLocationId" TEXT,
    "supplierCompanyShortName" TEXT,
    "supplierTravelSector" TEXT,
    "supplierCode" TEXT,
    "pnrId" TEXT NOT NULL,
    CONSTRAINT "OtherTravelSegment_startLocationId_fkey" FOREIGN KEY ("startLocationId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OtherTravelSegment_endLocationId_fkey" FOREIGN KEY ("endLocationId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "OtherTravelSegment_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "HotelInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "roomTypeCode" TEXT,
    "rate" REAL,
    "rateType" TEXT,
    "hotelName" TEXT,
    "customerName" TEXT,
    "propertyID" TEXT,
    "otherTravelSegmentId" TEXT NOT NULL,
    CONSTRAINT "HotelInfo_otherTravelSegmentId_fkey" FOREIGN KEY ("otherTravelSegmentId") REFERENCES "OtherTravelSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CarInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "rateType" TEXT,
    "rate" REAL,
    "ratePeriod" TEXT,
    "otherTravelSegmentId" TEXT NOT NULL,
    CONSTRAINT "CarInfo_otherTravelSegmentId_fkey" FOREIGN KEY ("otherTravelSegmentId") REFERENCES "OtherTravelSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "StructuredPnrHistory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pnrId" TEXT NOT NULL,
    CONSTRAINT "StructuredPnrHistory_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PnrHistoryItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "action" TEXT,
    "structuredPnrHistoryId" TEXT NOT NULL,
    "docSsrChangeId" TEXT,
    CONSTRAINT "PnrHistoryItem_structuredPnrHistoryId_fkey" FOREIGN KEY ("structuredPnrHistoryId") REFERENCES "StructuredPnrHistory" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "PnrHistoryItem_docSsrChangeId_fkey" FOREIGN KEY ("docSsrChangeId") REFERENCES "DocSSR" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SeatInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "airline" TEXT,
    "flightNumber" TEXT,
    "status" TEXT,
    "departureDate" DATETIME,
    "serviceQuantity" INTEGER,
    "departureAirportId" TEXT,
    "arrivalAirportId" TEXT,
    "seatNumberValue" TEXT,
    "psgrReference" TEXT,
    "givenName" TEXT,
    "middleName" TEXT,
    "surnamePrefix" TEXT,
    "surname" TEXT,
    "nameTitle" TEXT,
    "pnrHistoryItemId" TEXT NOT NULL,
    CONSTRAINT "SeatInfo_departureAirportId_fkey" FOREIGN KEY ("departureAirportId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "SeatInfo_arrivalAirportId_fkey" FOREIGN KEY ("arrivalAirportId") REFERENCES "AirportInfo" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "SeatInfo_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "BagInfo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "issuerCode" TEXT,
    "serialNumber" TEXT,
    "sequenceCount" INTEGER,
    "baggagePool" TEXT,
    "unitOfMeasureQuantity" INTEGER,
    "unitOfMeasureCode" TEXT,
    "flightNumber" TEXT,
    "departureDate" DATETIME,
    "carrierCode" TEXT,
    "boardPoint" TEXT,
    "offPoint" TEXT,
    "pnrHistoryItemId" TEXT NOT NULL,
    CONSTRAINT "BagInfo_pnrHistoryItemId_fkey" FOREIGN KEY ("pnrHistoryItemId") REFERENCES "PnrHistoryItem" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "BoardingPassRecord" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "pnrId" TEXT NOT NULL,
    "passengerId" TEXT NOT NULL,
    "passengerDescription" INTEGER NOT NULL,
    "checkInSource" TEXT,
    "boardingPassIssuanceSource" TEXT,
    "issuanceDate" DATETIME,
    "documentType" TEXT NOT NULL,
    "boardingPassIssuerDesignator" TEXT,
    "baggageTagNumber" TEXT,
    "firstBaggageTagNumber" TEXT,
    "secondBaggageTagNumber" TEXT,
    "securityDataType" TEXT,
    "securityData" TEXT,
    CONSTRAINT "BoardingPassRecord_pnrId_fkey" FOREIGN KEY ("pnrId") REFERENCES "PNR" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "BoardingPassRecord_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "FlightLegsRecord" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "boardingPassRecordId" TEXT NOT NULL,
    "flightSegmentId" TEXT NOT NULL,
    "compartmentCode" TEXT NOT NULL,
    "seatNumber" TEXT,
    "checkInSequenceNumber" INTEGER,
    "Remark" TEXT,
    CONSTRAINT "FlightLegsRecord_boardingPassRecordId_fkey" FOREIGN KEY ("boardingPassRecordId") REFERENCES "BoardingPassRecord" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "FlightLegsRecord_flightSegmentId_fkey" FOREIGN KEY ("flightSegmentId") REFERENCES "FlightSegment" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "refreshToken" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "token" TEXT NOT NULL,
    "expiresAt" DATETIME NOT NULL,
    "crewIdentityId" TEXT NOT NULL,
    CONSTRAINT "refreshToken_crewIdentityId_fkey" FOREIGN KEY ("crewIdentityId") REFERENCES "CrewIdentity" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "CrewIdentity_email_key" ON "CrewIdentity"("email");

-- CreateIndex
CREATE UNIQUE INDEX "PassengerUser_email_key" ON "PassengerUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "PNRGOVMessage_transactionIdentifier_key" ON "PNRGOVMessage"("transactionIdentifier");

-- CreateIndex
CREATE UNIQUE INDEX "PNRGOVMessage_correlationID_key" ON "PNRGOVMessage"("correlationID");

-- CreateIndex
CREATE UNIQUE INDEX "Originator_pnrGovMessageId_key" ON "Originator"("pnrGovMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "FlightLeg_pnrGovMessageId_key" ON "FlightLeg"("pnrGovMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "PNRsContainer_pnrGovMessageId_key" ON "PNRsContainer"("pnrGovMessageId");

-- CreateIndex
CREATE UNIQUE INDEX "UniqueId_bookingRefId_key" ON "UniqueId"("bookingRefId");

-- CreateIndex
CREATE UNIQUE INDEX "UniqueId_requestorId_key" ON "UniqueId"("requestorId");

-- CreateIndex
CREATE UNIQUE INDEX "UniqueId_pnrHistoryCreditId_key" ON "UniqueId"("pnrHistoryCreditId");

-- CreateIndex
CREATE UNIQUE INDEX "BookingRef_uniqueIdDetailsId_key" ON "BookingRef"("uniqueIdDetailsId");

-- CreateIndex
CREATE UNIQUE INDEX "SSRItem_pnrHistoryItemId_key" ON "SSRItem"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "OSIItem_pnrHistoryItemId_key" ON "OSIItem"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "POS_pnrId_key" ON "POS"("pnrId");

-- CreateIndex
CREATE UNIQUE INDEX "POSSource_requestorId_key" ON "POSSource"("requestorId");

-- CreateIndex
CREATE UNIQUE INDEX "ContactInformation_passengerId_key" ON "ContactInformation"("passengerId");

-- CreateIndex
CREATE UNIQUE INDEX "ContactAddressLine_contactInfoId_order_key" ON "ContactAddressLine"("contactInfoId", "order");

-- CreateIndex
CREATE UNIQUE INDEX "Passenger_checkInBoardingNumberId_key" ON "Passenger"("checkInBoardingNumberId");

-- CreateIndex
CREATE UNIQUE INDEX "Passenger_pnrHistoryItemId_key" ON "Passenger"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "PassengerMiddleName_passengerId_order_key" ON "PassengerMiddleName"("passengerId", "order");

-- CreateIndex
CREATE UNIQUE INDEX "PassengerNameTitle_passengerId_order_key" ON "PassengerNameTitle"("passengerId", "order");

-- CreateIndex
CREATE UNIQUE INDEX "TotalFare_ticketDocumentId_key" ON "TotalFare"("ticketDocumentId");

-- CreateIndex
CREATE UNIQUE INDEX "PriceInfo_ticketDocumentId_key" ON "PriceInfo"("ticketDocumentId");

-- CreateIndex
CREATE UNIQUE INDEX "DocSSR_passengerId_key" ON "DocSSR"("passengerId");

-- CreateIndex
CREATE UNIQUE INDEX "DocFlightInfo_docSsrId_key" ON "DocFlightInfo"("docSsrId");

-- CreateIndex
CREATE UNIQUE INDEX "PnrHistoryCredit_originatorId_key" ON "PnrHistoryCredit"("originatorId");

-- CreateIndex
CREATE UNIQUE INDEX "FlightSegment_pnrHistoryItemId_key" ON "FlightSegment"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "SeatNumber_boardingNumberInfoId_key" ON "SeatNumber"("boardingNumberInfoId");

-- CreateIndex
CREATE UNIQUE INDEX "HotelInfo_otherTravelSegmentId_key" ON "HotelInfo"("otherTravelSegmentId");

-- CreateIndex
CREATE UNIQUE INDEX "CarInfo_otherTravelSegmentId_key" ON "CarInfo"("otherTravelSegmentId");

-- CreateIndex
CREATE UNIQUE INDEX "PnrHistoryItem_docSsrChangeId_key" ON "PnrHistoryItem"("docSsrChangeId");

-- CreateIndex
CREATE UNIQUE INDEX "SeatInfo_pnrHistoryItemId_key" ON "SeatInfo"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "BagInfo_pnrHistoryItemId_key" ON "BagInfo"("pnrHistoryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "BoardingPassRecord_passengerId_key" ON "BoardingPassRecord"("passengerId");
