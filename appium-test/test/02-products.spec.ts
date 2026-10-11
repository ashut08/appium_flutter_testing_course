
import { expect } from '@wdio/globals';


import { scrollTo, logintoShop, tap, waitFor, waitForAbsent, key, textOf } from '../helper/flutter.js';
import { byText, descendant } from 'appium-flutter-finder';



describe('Product List Feature', () => {
    before(async () => {
        await logintoShop();
    });


    //TC 01
    it('show the title and an empty cart', async () => {

        expect(await textOf(key('products_title'))).toBe('Products');

        expect(await textOf(key('cart_count'))).toBe('0')
    }



    );


    it('scroll down to reach the last product', async () => {
        await scrollTo(key('product_list'), key('product_20'));

        await waitFor(descendant({ of: key('product_20'), matching: byText('Grapes') }));



    })





});
