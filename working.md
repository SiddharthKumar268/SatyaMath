# Blockchain E-Voting System - Complete Setup Guide

## 📋 Prerequisites

- Node.js installed
- MetaMask browser extension installed
- PowerShell or Command Prompt

---

## 🚀 ONE-TIME SETUP

### Step 1: Install Dependencies

```bash
cd D:\Python\Avi.py\blockchain-evoting
npm install
npm install -g ganache
```

---

## 🔄 EVERY TIME YOU START THE SYSTEM

### Step 1: Start Ganache (Terminal 1)

Open PowerShell Terminal 1:

```bash
cd D:\Python\Avi.py\blockchain-evoting
ganache -h 127.0.0.1 -p 8545 -d
```

**Keep this terminal open!**

You'll see:
```
Available Accounts
==================
(0) 0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1 (1000 ETH)
...

Private Keys
==================
(0) 0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d
...

RPC Listening on 127.0.0.1:8545
```

---

### Step 2: Deploy Contract (Terminal 2)

Open NEW PowerShell Terminal 2:

```bash
cd D:\Python\Avi.py\blockchain-evoting
npx hardhat compile
npx hardhat run --network localhost scripts/deploy.js
```

**IMPORTANT: Copy the contract address from the output!**

Example:
```
📍 Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

**Also check Terminal 1 for:**
```
Contract created: 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

Both addresses must match!

---

### Step 3: Configure MetaMask (First Time Only)

#### Add Ganache Network:

1. Open MetaMask
2. Click network dropdown (top-left)
3. Click "Add Network" → "Add a network manually"
4. Fill in:
   ```
   Network Name: Ganache Local
   RPC URL: http://127.0.0.1:8545
   Chain ID: 1337
   Currency Symbol: ETH
   ```
5. Click "Save"

#### Import Owner Account:

1. MetaMask → Click account icon (top-right)
2. Click "Add account or hardware wallet"
3. Click "Import account"
4. Paste private key from Terminal 1:
   ```
   0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d
   ```
5. Click "Import"

You should see **1000 ETH**!

---

### Step 4: Start Web Server (Terminal 2 or Terminal 3)

```bash
cd D:\Python\Avi.py\blockchain-evoting
npx http-server -p 3000
```

**Keep this running!**

---

### Step 5: Open Voting App

1. Open browser: **http://127.0.0.1:3000**
2. Paste the contract address (from Step 2)
3. Click **"Connect MetaMask"** → Select account → "Next" → "Connect"
4. Click **"Load Contract"**

✅ You should see:
- Status bar with your account
- Current Phase: "Created" (yellow)
- Owner Controls section
- 4 proposal cards (Candidate A, B, C, D)

---

## 🗳️ COMPLETE VOTING PROCESS

### Phase 1: Setup (Owner)

#### 1. Add Eligible Voters

In "Add Eligible Voter Address" field, add these addresses one by one:

```
0xFFcf8FDEE72ac11b5c542428B35EEF5769C409f0
```
```
0x22d491Bde2303f2f43325b2108D26f1eAbA1e32b
```
```
0xE11BA2b4D45Eaed5996Cd0823791E0C93114882d
```

Click "Add Eligible Voter" for each → Confirm in MetaMask

#### 2. Start Commit Phase

Click **"Start Commit Phase"** (green button) → Confirm in MetaMask

✅ Badge changes to **"Commit Phase"** (green)

---

### Phase 2: Vote as First Voter

#### 1. Import Voter Account to MetaMask

- MetaMask → Account icon → "Add account or hardware wallet" → "Import account"
- Paste private key:
  ```
  0x6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1
  ```
- Click "Import"

#### 2. Reconnect with New Account

- Refresh page (F5)
- Click "Connect MetaMask" → Select NEW account → "Next" → "Connect"
- Paste contract address
- Click "Load Contract"

#### 3. Cast Vote (Commit)

- Select proposal: **"0: Candidate A"**
- Enter secret: `mysecret123`
- Click **"🔒 Commit Vote"** → Confirm in MetaMask

✅ "Vote committed successfully!"

---

### Phase 3: Vote as Second Voter

#### 1. Import Second Voter

- MetaMask → Import account
- Private key: `0x6370fd033278c143179d81c5526140625662b8daa446c22ee2d73db3707e620c`

#### 2. Vote

- Refresh, reconnect, load contract
- Select: **"1: Candidate B"**
- Secret: `voter2secret`
- Commit vote

---

### Phase 4: Start Reveal Phase (Owner)

#### 1. Switch to Owner Account

- MetaMask → Select first account (0x90F8b...8c9C1)
- Refresh page
- Connect and load contract

#### 2. Start Reveal

- Click **"Start Reveal Phase"** (blue button) → Confirm

✅ Badge changes to **"Reveal Phase"** (blue)

---

### Phase 5: Reveal Votes

#### 1. Reveal First Vote

- Switch to first voter account in MetaMask
- Refresh, connect, load contract
- Select: **"0: Candidate A"** (SAME as committed)
- Secret: `mysecret123` (SAME as committed)
- Click **"🔓 Reveal Vote"** → Confirm
- Click **"🔄 Refresh Results"**

✅ **Candidate A: 1 vote**

#### 2. Reveal Second Vote

- Switch to second voter account
- Refresh, connect, load contract
- Select: **"1: Candidate B"**
- Secret: `voter2secret`
- Reveal vote

✅ **Candidate B: 1 vote**

---

### Phase 6: End Voting (Owner)

- Switch to owner account
- Refresh, connect, load contract
- Click **"End Voting"** (red button) → Confirm

✅ Badge changes to **"Ended"** (gray)

---

## 📊 FINAL RESULTS

Click **"🔄 Refresh Results"**

You should see:
- Candidate A: 1 vote
- Candidate B: 1 vote
- Candidate C: 0 votes
- Candidate D: 0 votes

🎉 **Voting Complete!**

---

## 🔧 TROUBLESHOOTING

### Issue: "MetaMask not found"

**Solution:** Make sure you're accessing via `http://127.0.0.1:3000` (not file:// or Live Server)

---

### Issue: "Failed to load contract"

**Solution:**
1. Make sure Ganache is running (Terminal 1 shows `RPC Listening on 127.0.0.1:8545`)
2. Make sure you deployed contract (Terminal 2 completed successfully)
3. Use the contract address from **Terminal 1** (`Contract created: 0x...`)
4. MetaMask must be on "Ganache Local" network

---

### Issue: "No contract found at this address"

**Solution:**
1. Redeploy contract: `npx hardhat run --network localhost scripts/deploy.js`
2. Use the NEW contract address
3. Clear MetaMask cache: Settings → Advanced → "Clear activity tab data"
4. Refresh browser page

---

### Issue: "Failed to add eligible voter"

**Solution:** You can only add voters in "Created" phase. If you already started commit phase, redeploy a fresh contract.

---

### Issue: Connection errors

**Solution:**
1. Close browser completely
2. Stop Ganache (Ctrl+C)
3. Restart Ganache: `ganache -h 127.0.0.1 -p 8545 -d`
4. Redeploy contract
5. Clear MetaMask cache
6. Reopen browser and reconnect

---

## 📝 IMPORTANT NOTES

1. **Every time you restart Ganache, you MUST redeploy the contract** - the blockchain resets
2. **Always use the contract address from Terminal 1** (`Contract created:`) - it's the most accurate
3. **Never close Terminal 1 (Ganache)** while testing - it's your blockchain
4. **MetaMask must be on "Ganache Local" network** - check top-left corner
5. **Contract addresses change with each deployment** - always use the latest one
6. **Use http-server, NOT Live Server** - Live Server causes Web3 connection issues
7. **The `-d` flag in Ganache** gives you the same accounts every time (deterministic)

---

## 🔑 DEFAULT ACCOUNTS (with -d flag)

**Owner/Deployer:**
- Address: `0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1`
- Private Key: `0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d`

**Voter 1:**
- Address: `0xFFcf8FDEE72ac11b5c542428B35EEF5769C409f0`
- Private Key: `0x6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1`

**Voter 2:**
- Address: `0x22d491Bde2303f2f43325b2108D26f1eAbA1e32b`
- Private Key: `0x6370fd033278c143179d81c5526140625662b8daa446c22ee2d73db3707e620c`

---

## 🎓 HOW IT WORKS

### Commit-Reveal Voting

1. **Commit Phase:** Voters submit encrypted votes (hash of proposal + secret)
   - No one can see which candidate was chosen
   - Prevents vote manipulation

2. **Reveal Phase:** Voters prove their vote by revealing the proposal ID and secret
   - Contract verifies the hash matches
   - Vote is counted transparently

3. **Security:** Once committed, votes cannot be changed. The secret ensures only the voter can reveal their own vote.

---

## 📂 PROJECT STRUCTURE

```
blockchain-evoting/
├── contracts/
│   └── Voting.sol           # Smart contract
├── scripts/
│   └── deploy.js            # Deployment script
├── hardhat.config.js        # Hardhat configuration
├── package.json             # Dependencies
├── index.html               # Frontend UI
└── README.md                # This file
```

---

## 🚀 QUICK START COMMANDS

```bash
# Terminal 1 - Start Ganache
ganache -h 127.0.0.1 -p 8545 -d

# Terminal 2 - Deploy Contract
npx hardhat run --network localhost scripts/deploy.js

# Terminal 2/3 - Start Web Server
npx http-server -p 3000

# Browser
# Open: http://127.0.0.1:3000
```

---

## 💡 TIPS

- Save contract addresses in a text file for reference
- Keep Terminal 1 (Ganache) always running during testing
- Use different browser profiles for different voter accounts (easier than switching MetaMask accounts)
- The auto-refresh happens every 10 seconds, or click "Refresh Results" manually

---

## 📧 SUPPORT

If you encounter issues:
1. Check Terminal 1 - is Ganache running?
2. Check MetaMask - are you on "Ganache Local" network?
3. Try the troubleshooting section above
4. Redeploy contract and start fresh

---

**Happy Voting! 🗳️**

npx http-server -p 3000

npx http-server -p 3000 -o welcome.html
