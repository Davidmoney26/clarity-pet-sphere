import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can register a new pet profile",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const block = chain.mineBlock([
      Tx.contractCall("pet-profile", "register-pet", 
        [types.utf8("Max"), types.utf8("Dog"), types.uint(1625097600)], 
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result.expectOk(), true);
  },
});

Clarinet.test({
  name: "Cannot register duplicate pet profile",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    let block = chain.mineBlock([
      Tx.contractCall("pet-profile", "register-pet",
        [types.utf8("Max"), types.utf8("Dog"), types.uint(1625097600)],
        deployer.address
      )
    ]);
    block = chain.mineBlock([
      Tx.contractCall("pet-profile", "register-pet",
        [types.utf8("Buddy"), types.utf8("Dog"), types.uint(1625097600)],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result.expectErr(), 'u409');
  },
});
