const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");

module.exports = async function (deployer) {
  //deplying the token
  await deployer.deploy(Token);

  //assigning the token to a varialble to access its address
  const token = await Token.deployed();

  //deploy the dbank and pass in the tokens adderss for futheer minting of the token
  await deployer.deploy(dBank, token.address);

  //assinging the dbank to a variable to get its access
  const dbank = await dBank.deployed();

  //change the minter role to dBank from the deployer/formerMinter.
  await token.passTheMinterRole(dbank.address);
};
