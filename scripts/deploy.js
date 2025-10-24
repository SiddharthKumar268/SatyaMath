const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());

  // Define your candidates/proposals here
  const proposalNames = ["Candidate A", "Candidate B", "Candidate C", "Candidate D"];

  console.log("\nDeploying Voting contract with proposals:", proposalNames);

  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy(proposalNames);

  await voting.waitForDeployment();

  const contractAddress = await voting.getAddress();
  
  console.log("\n✅ Voting contract deployed successfully!");
  console.log("📍 Contract Address:", contractAddress);
  console.log("\n🔥 COPY THIS ADDRESS AND PASTE IT IN THE FRONTEND 🔥\n");
  console.log("Next steps:");
  console.log("1. Copy the contract address above");
  console.log("2. Open index.html in your browser");
  console.log("3. Paste the address in the 'Contract Address' field");
  console.log("4. Click 'Connect MetaMask' then 'Load Contract'");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });