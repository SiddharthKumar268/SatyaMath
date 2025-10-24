# Backend Setup Guide - PostgreSQL Integration

## 📋 Additional Prerequisites

- PostgreSQL installed (download from https://www.postgresql.org/download/)
- pgAdmin 4 (comes with PostgreSQL installer)

---

## 🗄️ STEP 1: PostgreSQL Setup

### 1. Install PostgreSQL

1. Download PostgreSQL installer for Windows
2. During installation:
   - Set password for `postgres` user (e.g., `admin123`)
   - Port: `5432` (default)
   - Install pgAdmin 4

### 2. Create Database

Open pgAdmin 4 or use psql:

```sql
-- Create database
CREATE DATABASE evoting_db;

-- Connect to database
\c evoting_db;

-- Create tables
CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) UNIQUE NOT NULL,
    owner_address VARCHAR(42) NOT NULL,
    deployed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE proposals (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) NOT NULL,
    proposal_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    FOREIGN KEY (contract_address) REFERENCES contracts(contract_address),
    UNIQUE(contract_address, proposal_id)
);

CREATE TABLE voters (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) NOT NULL,
    voter_address VARCHAR(42) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    added_by VARCHAR(42) NOT NULL,
    FOREIGN KEY (contract_address) REFERENCES contracts(contract_address),
    UNIQUE(contract_address, voter_address)
);

CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) NOT NULL,
    voter_address VARCHAR(42) NOT NULL,
    proposal_id INTEGER,
    commit_hash VARCHAR(66),
    committed_at TIMESTAMP,
    revealed_at TIMESTAMP,
    transaction_hash VARCHAR(66),
    FOREIGN KEY (contract_address) REFERENCES contracts(contract_address),
    UNIQUE(contract_address, voter_address)
);

CREATE TABLE voting_phases (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) NOT NULL,
    phase VARCHAR(20) NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_by VARCHAR(42) NOT NULL,
    FOREIGN KEY (contract_address) REFERENCES contracts(contract_address)
);

CREATE TABLE results (
    id SERIAL PRIMARY KEY,
    contract_address VARCHAR(42) NOT NULL,
    proposal_id INTEGER NOT NULL,
    vote_count INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_address) REFERENCES contracts(contract_address),
    UNIQUE(contract_address, proposal_id)
);

-- Create indexes for better performance
CREATE INDEX idx_votes_contract ON votes(contract_address);
CREATE INDEX idx_votes_voter ON votes(voter_address);
CREATE INDEX idx_proposals_contract ON proposals(contract_address);
CREATE INDEX idx_voters_contract ON voters(contract_address);
CREATE INDEX idx_phases_contract ON voting_phases(contract_address);
```

---

## 🚀 STEP 2: Backend Installation

### 1. Install Backend Dependencies

```bash
cd D:\Python\Avi.py\blockchain-evoting
npm install express pg dotenv cors body-parser
```

### 2. Create Environment File

Create `.env` file in project root:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=evoting_db
DB_USER=postgres
DB_PASSWORD=admin123

# Server Configuration
PORT=3001
NODE_ENV=development

# Blockchain Configuration
GANACHE_URL=http://127.0.0.1:8545
```

---

## 📁 STEP 3: Backend File Structure

Create this structure:

```
blockchain-evoting/
├── backend/
│   ├── server.js           # Main server file
│   ├── db.js               # Database connection
│   ├── routes/
│   │   ├── contracts.js    # Contract routes
│   │   ├── voters.js       # Voter routes
│   │   ├── votes.js        # Voting routes
│   │   └── analytics.js    # Analytics routes
│   └── middleware/
│       └── errorHandler.js # Error handling
├── contracts/
├── scripts/
├── .env
└── package.json
```

---

## 💻 STEP 4: Backend Code Files

I'll provide all the backend code in separate artifacts.

---

## 🔄 UPDATED STARTUP PROCESS

### Terminal 1: Ganache
```bash
cd D:\Python\Avi.py\blockchain-evoting
ganache -h 127.0.0.1 -p 8545 -d
```

### Terminal 2: Deploy Contract
```bash
npx hardhat run --network localhost scripts/deploy.js
```

### Terminal 3: Backend API Server
```bash
node backend/server.js
```
You should see: `✅ Backend API running on http://localhost:3001`

### Terminal 4: Frontend Web Server
```bash
npx http-server -p 3000
```

---

## 🌐 API ENDPOINTS

### Contract Endpoints
- `POST /api/contracts` - Register new contract
- `GET /api/contracts/:address` - Get contract details
- `GET /api/contracts` - List all contracts

### Voter Endpoints
- `POST /api/voters` - Add eligible voter
- `GET /api/voters/:contractAddress` - Get all voters for contract

### Voting Endpoints
- `POST /api/votes/commit` - Record commit transaction
- `POST /api/votes/reveal` - Record reveal transaction
- `GET /api/votes/:contractAddress` - Get all votes for contract

### Phase Endpoints
- `POST /api/phases` - Record phase change
- `GET /api/phases/:contractAddress` - Get phase history

### Analytics Endpoints
- `GET /api/analytics/:contractAddress/summary` - Voting summary
- `GET /api/analytics/:contractAddress/turnout` - Voter turnout
- `GET /api/analytics/:contractAddress/timeline` - Voting timeline

---

## 🧪 TESTING THE BACKEND

### Test Database Connection
```bash
node backend/db.js
```
Should show: `✅ PostgreSQL connected successfully`

### Test API Endpoints

Using PowerShell:

```powershell
# Test health check
Invoke-WebRequest -Uri http://localhost:3001/api/health

# Register contract
$body = @{
    contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    ownerAddress = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:3001/api/contracts -Method POST -Body $body -ContentType "application/json"
```

---

## 📊 DATABASE QUERIES FOR ANALYTICS

```sql
-- Get total votes for a contract
SELECT COUNT(*) FROM votes 
WHERE contract_address = '0x...' AND revealed_at IS NOT NULL;

-- Get voter turnout percentage
SELECT 
    (COUNT(DISTINCT v.voter_address)::float / COUNT(DISTINCT vo.voter_address) * 100) as turnout
FROM votes v
RIGHT JOIN voters vo ON v.voter_address = vo.voter_address
WHERE vo.contract_address = '0x...';

-- Get results by proposal
SELECT p.name, COALESCE(r.vote_count, 0) as votes
FROM proposals p
LEFT JOIN results r ON p.proposal_id = r.proposal_id AND p.contract_address = r.contract_address
WHERE p.contract_address = '0x...'
ORDER BY votes DESC;

-- Get voting timeline
SELECT 
    DATE_TRUNC('hour', committed_at) as hour,
    COUNT(*) as commits
FROM votes
WHERE contract_address = '0x...'
GROUP BY hour
ORDER BY hour;
```

---

## 🔐 SECURITY CONSIDERATIONS

1. **Environment Variables**: Never commit `.env` file to Git
2. **SQL Injection**: Using parameterized queries (pg library handles this)
3. **CORS**: Configured for localhost only in development
4. **Rate Limiting**: Consider adding express-rate-limit for production
5. **Input Validation**: Validate Ethereum addresses and transaction hashes

---

## 🐛 TROUBLESHOOTING

### Issue: "Cannot connect to PostgreSQL"
**Solution:**
1. Check if PostgreSQL service is running (Windows Services)
2. Verify credentials in `.env` file
3. Test connection: `psql -U postgres -d evoting_db`

### Issue: "Port 3001 already in use"
**Solution:**
1. Change PORT in `.env` file
2. Or kill process: `netstat -ano | findstr :3001` then `taskkill /F /PID <PID>`

### Issue: "CORS error"
**Solution:** Make sure frontend and backend are running on correct ports (3000 and 3001)

---

## 📈 BENEFITS OF DATABASE INTEGRATION

1. **Audit Trail**: Complete history of all transactions
2. **Analytics**: Generate reports and visualizations
3. **Backup**: Data persists even if blockchain resets
4. **Query Performance**: Fast queries without blockchain calls
5. **Scalability**: Handle large-scale elections
6. **Compliance**: Meet regulatory requirements for record-keeping

---

## 🎯 NEXT STEPS

After setup:
1. Integrate frontend with backend API
2. Add real-time updates using WebSockets
3. Create admin dashboard for monitoring
4. Add export functionality (CSV, PDF reports)
5. Implement email notifications
6. Add backup and restore features

---

**Backend is now ready! 🚀**