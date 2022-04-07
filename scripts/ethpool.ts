import { ethers, network } from 'hardhat'


const ethPool =async () => {
  const poll = await ethers.getContract('EthPool')
}

ethPool()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(1)
  })