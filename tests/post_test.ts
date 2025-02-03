import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create a new post",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const block = chain.mineBlock([
      Tx.contractCall("post", "create-post",
        [types.utf8("My first post about my pet!")],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result.expectOk(), true);
  },
});

Clarinet.test({
  name: "Can like a post",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    let block = chain.mineBlock([
      Tx.contractCall("post", "create-post",
        [types.utf8("My first post about my pet!")],
        deployer.address
      )
    ]);
    block = chain.mineBlock([
      Tx.contractCall("post", "like-post",
        [types.uint(0)],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result.expectOk(), true);
  },
});
