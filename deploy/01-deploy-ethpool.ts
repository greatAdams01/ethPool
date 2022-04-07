import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
import { ethers } from 'hardhat'

const deployGovernaceToken: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  // @ts-ignore
  const { getNamedAccounts, deployments } = hre
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log('Deploying Ethpool...')
  const ethPool = await deploy('EthPool', {
    from: deployer,
    args: [],
    log: true,
    // waitConfirmations
  })
  log(`Deployed Ethpool address ${ethPool.address}`)
}


export default deployGovernaceToken;