import { key, waitFor } from "../helper/flutter.js";

import { expect, driver } from '@wdio/globals'




describe('smoke test', () => {



    it('connect to the flutter app and shows the honme screen', async () => {


        expect(await driver.getContext()).toBe('FLUTTER');


        expect(await driver.getContexts()).toContain('NATIVE_APP');



        await waitFor(key('open_login'), 30000)



    })






})