-- Companies Table
CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    industry VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Company Branches Table
CREATE TABLE IF NOT EXISTS company_branches (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    contact_number VARCHAR(15),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Roles Table
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,  -- E.g., 'room_manager', 'employee'
    description TEXT
);

-- Rooms Table
CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    branch_id INT REFERENCES company_branches(id) ON DELETE CASCADE,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type VARCHAR(50),  -- E.g., conference, office
    description TEXT,
    capacity INT CHECK (capacity > 0),
    features JSONB,  -- E.g., { "wifi": true, "tv": false }
    status VARCHAR(20) DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES companies(id) ON DELETE CASCADE,
    companyloginid VARCHAR(20) NOT NULL,         -- Unique login ID for each company
    employeeid VARCHAR(20) NOT NULL,             -- Employee ID within the company
    fullname VARCHAR(255) NOT NULL,              -- Full name of the user, does not have to be unique
    password VARCHAR(255) NOT NULL,              -- Password stored securely
    role_id INT REFERENCES roles(id),            -- Reference to role (e.g., room_manager)
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (companyloginid, employeeid)          -- Unique constraint on companyloginid and employeeid
);

-- Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    room_id INT REFERENCES rooms(id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'requested',  -- E.g., requested, approved, declined
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (room_id, start_time, end_time)  -- Ensures no overlapping bookings for the same room
);
