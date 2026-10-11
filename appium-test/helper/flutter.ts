
import { driver } from '@wdio/globals'

import { byValueKey } from 'appium-flutter-finder';



export const key = (finder: string) => byValueKey(finder);
// wait for


export async function waitFor(finder: string, timoutMs = 3000) {

    await driver.execute('flutter:waitFor', finder, timoutMs)

}


// wait for absent


export async function waitForAbsent(finder: string, timoutMs = 1000) {

    await driver.execute('flutter:waitForAbsent', finder, timoutMs)

}


//if it find location then it will return true else false 

export async function isPresent(finder: string, timeoutMs = 1000) {

    try {
        await waitFor(finder, timeoutMs)

        return true;
    } catch {
        return false;
    }
}


//interaction helpers


export async function tap(finder: string) {
    await waitFor(finder);
    await driver.elementClick(finder);

}



export async function type(finder: string, text: string) {


    await waitFor(finder);
    await driver.elementSendKeys(finder, text);
}



export async function textOf(finder: string) {

    await waitFor(finder);

    return await driver.getElementText(finder);

}


export async function scrollTo(
    list: string,
    item: string,

    dy = -400,

    maxScroll = 15

) {

    for (let i = 0; i < maxScroll++; i++) {
        //Give the list time to stop moving befor cheking the item is present or not  after scrolling up  
        if (await isPresent(item, 1500)) {
            //if item is there but not in middle then we are saying bring it to middle
            await driver.execute('flutter:scrollIntoView', item, {
                aligmnet: 0.5
            });
            return;
        }



        await driver.execute('flutter:scroll', list, {
            dx: 0,
            dy,
            durationMilliseconds: 500, //a slow drag so the does not move fast 
            frequency: 30,
        });

    }


    await waitFor(item); //it will if item not found with error 


}


// user journey helpers class

export async function openLogin() {

    await waitFor(key('open_login'));

    await tap(key('open_login'));
    await waitFor(key('login_button'));

}




export async function login(email = 'student@test.com', password = 'password123') {

    await type(key('email_field'), email);

    await type(key('password_field'), password);


    await tap(key('login_button'))





}


export async function logintoShop() {
    await openLogin();
    await login();
    await waitFor(key('product_list'));


}
