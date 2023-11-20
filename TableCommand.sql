-- Create a custom URL type
CREATE DOMAIN url AS VARCHAR(2000)
  CHECK (VALUE ~* '^https?://[^\s]+$');

-- COMPANY table
CREATE TABLE COMPANY (
    CompanyId VARCHAR(36) PRIMARY KEY NOT NULL,
    CompanyName VARCHAR(35) NOT NULL,
    CompanyAddress VARCHAR(300) NOT NULL,
    CompanyPhone CHAR(14) NOT NULL
);

-- ADVERTISEMENT table
CREATE TABLE ADVERTISEMENT (
    AdId VARCHAR(36) PRIMARY KEY NOT NULL,
    StartDate TIMESTAMP(0) NOT NULL,
    EndDate TIMESTAMP(0),
    CompanyId VARCHAR(36) REFERENCES COMPANY(CompanyId) NOT NULL,
    AdminId VARCHAR(36) NOT NULL
);

-- ADMIN table
CREATE TABLE ADMIN (
    AdminId VARCHAR(36) PRIMARY KEY NOT NULL,
    AdminFName VARCHAR(35) NOT NULL,
    AdminLName VARCHAR(35) NOT NULL,
    AdminPhone CHAR(14) NOT NULL
);

-- user table
CREATE TABLE "user" (
    Email VARCHAR(319) PRIMARY KEY NOT NULL,
    Fname VARCHAR(35) NOT NULL,
    Lname VARCHAR(35) NOT NULL,
    ProfileImage url,
    ExpiredDateKYC TIMESTAMP(0)
);

-- ISSUE table
CREATE TABLE ISSUE (
    IssueId VARCHAR(36) PRIMARY KEY NOT NULL,
    IssueType VARCHAR(100) NOT NULL,
    IsResolved BOOLEAN NOT NULL,
    IssueTimeStamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    IssueMessage TEXT NOT NULL,
    IssueImage url,
    UserEmail VARCHAR(319) REFERENCES "user"(Email) NOT NULL 
);

-- ISSUE_REVIEW table
CREATE TABLE ISSUE_REVIEW (
    AdminId VARCHAR(36) REFERENCES ADMIN(AdminId) NOT NULL,
    IssueId VARCHAR(36) REFERENCES ISSUE(IssueId) NOT NULL,
    DateResolved TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY (AdminId, IssueId)
);

-- OWNER table
CREATE TABLE OWNER (
    OwnerEmail VARCHAR(319) PRIMARY KEY REFERENCES "user"(Email) NOT NULL
);

-- DWELLER table
CREATE TABLE DWELLER (
    DwellerEmail VARCHAR(319) PRIMARY KEY REFERENCES "user"(Email) NOT NULL
);

-- PROPERTY_REVIEW table
CREATE TABLE PROPERTY_REVIEW (
    PropertyId VARCHAR(36) PRIMARY KEY NOT NULL,
    DwellerEmail VARCHAR(319) REFERENCES DWELLER(DwellerEmail) NOT NULL,
    ReviewTimeStamp TIMESTAMP WITHOUT TIME ZONE,
    Image url,
    Score FLOAT(24) NOT NULL,
    Description VARCHAR(300) NOT NULL
);

-- like table
CREATE TABLE "like" (
    PropertyId VARCHAR(36) REFERENCES PROPERTY_REVIEW(PropertyId) NOT NULL,
    DwellerEmail VARCHAR(319) REFERENCES DWELLER(DwellerEmail) NOT NULL,
    PRIMARY KEY (PropertyId, DwellerEmail)
);

-- PROPERTY_LISTING table
-- Remove Image from property-listing table
CREATE TABLE PROPERTY_LISTING (
    PropertyId VARCHAR(36) PRIMARY KEY NOT NULL,
    OwnerEmail VARCHAR(319) REFERENCES OWNER(OwnerEmail) NOT NULL,
    OwnerContact VARCHAR(100) NOT NULL,
    Description VARCHAR(50) NOT NULL,
    ResidentialType VARCHAR(99) NOT NULL,
    ProjectName VARCHAR(50),
    Address VARCHAR(50) NOT NULL,
    Alley VARCHAR(50),
    Street VARCHAR(50) NOT NULL,
    SubDistrict VARCHAR(50) NOT NULL,
    District VARCHAR(50) NOT NULL,
    Province VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    PostalCode CHAR(5) NOT NULL,
    PropertyListTimeStamp TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

-- APPOINTMENT table
CREATE TABLE APPOINTMENT (
    AppointmentId VARCHAR(36) PRIMARY KEY NOT NULL,
    PropertyId VARCHAR(36) REFERENCES PROPERTY_LISTING(PropertyId) NOT NULL,
    DwellerEmail VARCHAR(319) REFERENCES DWELLER(DwellerEmail) NOT NULL,
    AppointmentTimeStamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    AppointmentDate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    IsConfirmed BOOLEAN NOT NULL,
    IsRejected BOOLEAN NOT NULL,
    Ismet BOOLEAN NOT NULL
);

-- IMAGE table
CREATE TABLE IMAGE (
    PropertyId VARCHAR(36) REFERENCES PROPERTY_LISTING(PropertyId) NOT NULL,
    Image url NOT NULL,
    PRIMARY KEY (PropertyId, Image)
);

-- PROPERTY_LISTING_FOR_SELL table
CREATE TABLE PROPERTY_LISTING_FOR_SELL (
    PropertyId VARCHAR(36) PRIMARY KEY REFERENCES PROPERTY_LISTING(PropertyId) NOT NULL,
    Price DOUBLE PRECISION NOT NULL,
    IsSold BOOLEAN NOT NULL
);

-- PROPERTY_LISTING_FOR_RENT table
CREATE TABLE PROPERTY_LISTING_FOR_RENT (
    PropertyId VARCHAR(36) PRIMARY KEY REFERENCES PROPERTY_LISTING(PropertyId) NOT NULL,
    PricePerMonth DOUBLE PRECISION NOT NULL,
    IsOccupied BOOLEAN NOT NULL
);

-- TRANSACTION table
CREATE TABLE TRANSACTION (
    TransactionId VARCHAR(36) PRIMARY KEY NOT NULL,
    Timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PaymentMethod CHAR(50) NOT NULL,
    isReleased BOOLEAN NOT NULL,
    isCanceled BOOLEAN NOT NULL,
    Amount DOUBLE PRECISION NOT NULL
);

-- RENT table
CREATE TABLE RENT (
    PropertyId VARCHAR(36) REFERENCES PROPERTY_LISTING_FOR_RENT(PropertyId) NOT NULL,
    DwellerEmail VARCHAR(319) REFERENCES DWELLER(DwellerEmail) NOT NULL,
    TransactionId VARCHAR(36) REFERENCES TRANSACTION(TransactionId) NOT NULL,
    RentStartDate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (PropertyId, DwellerEmail)
);

-- SELL table
CREATE TABLE SELL (
    PropertyId VARCHAR(36) REFERENCES PROPERTY_LISTING_FOR_SELL(PropertyId) NOT NULL,
    DwellerEmail VARCHAR(319) REFERENCES DWELLER(DwellerEmail) NOT NULL,
    TransactionId VARCHAR(36) REFERENCES TRANSACTION(TransactionId) NOT NULL,
    PRIMARY KEY (PropertyId, DwellerEmail)
);

-- copy csv


COPY COMPANY FROM '/docker-entrypoint-initdb.d/company.csv' WITH CSV HEADER;
COPY ADVERTISEMENT FROM '/docker-entrypoint-initdb.d/advertisment.csv' WITH CSV HEADER;
COPY "user" FROM '/docker-entrypoint-initdb.d/user.csv' WITH CSV HEADER;
COPY ADMIN FROM '/docker-entrypoint-initdb.d/admin.csv' WITH CSV HEADER;
COPY OWNER FROM '/docker-entrypoint-initdb.d/owner.csv' WITH CSV HEADER;
COPY DWELLER FROM '/docker-entrypoint-initdb.d/dweller.csv' WITH CSV HEADER;
COPY ISSUE FROM '/docker-entrypoint-initdb.d/issue.csv' WITH CSV HEADER;
COPY ISSUE_REVIEW FROM '/docker-entrypoint-initdb.d/issue_review.csv' WITH CSV HEADER;
COPY property_review FROM '/docker-entrypoint-initdb.d/property_review.csv' WITH CSV HEADER;
COPY "like" FROM '/docker-entrypoint-initdb.d/like.csv' WITH CSV HEADER;
COPY PROPERTY_LISTING FROM '/docker-entrypoint-initdb.d/property_listing.csv' WITH CSV HEADER;
COPY PROPERTY_LISTING_FOR_SELL FROM '/docker-entrypoint-initdb.d/property_for_sale.csv' WITH CSV HEADER;
COPY PROPERTY_LISTING_FOR_RENT  FROM '/docker-entrypoint-initdb.d/property_for_rent.csv' WITH CSV HEADER;
COPY TRANSACTION FROM '/docker-entrypoint-initdb.d/transaction.csv' WITH CSV HEADER;
COPY RENT FROM '/docker-entrypoint-initdb.d/rent.csv' WITH CSV HEADER;
COPY SELL FROM '/docker-entrypoint-initdb.d/sell.csv' WITH CSV HEADER;
COPY IMAGE FROM '/docker-entrypoint-initdb.d/image.csv' WITH CSV HEADER;
COPY APPOINTMENT FROM '/docker-entrypoint-initdb.d/appointment.csv' WITH CSV HEADER;