require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const URL = process.env.SUPABASE_URL;
const ANON = process.env.SUPABASE_ANON_KEY;
const SERVICE = process.env.SUPABASE_SERVICE_ROLE_KEY;

const anon = createClient(URL, ANON);
const service = createClient(URL, SERVICE);

async function test() {

  console.log('\n--- TEST 1: ANON (NOT LOGGED IN) ---');
  const anonResult = await anon.from('applications').select('*');
  console.log(anonResult);

  console.log('\n--- TEST 2: SERVICE ROLE ---');
  const serviceResult = await service.from('applications').select('*');
  console.log(serviceResult);

  console.log('\n--- TEST 3: AUTHENTICATED USER ---');

  const login = await anon.auth.signInWithPassword({
    email: "test@gmail.com",
    password: "password"
  });

  if (login.error) {
    console.error("Login failed:", login.error);
    return;
  }

  const authResult = await anon.from('applications').select('*');
  console.log(authResult);
}

test();

await anon.from('events').insert({
  application_id: "fe84b3e3-8732-437d-8052-1a74e7c863e7",
  event_type: "page_view"
});
