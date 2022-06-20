
import { test, expect } from '@playwright/test';
import { CoffeeShopPageFieldName, LandingPage } from './PageObjects';

const NEW_COFFEE_SHOP_NAME = "Jitters";


test.beforeEach(async ({ page }) => {
    await page.goto("/");
});

test.afterEach(async ({ page }) => {
    await page.goto("/");
    const coffeeShopListPage = await new LandingPage(page).manageCoffeeShops();
    await coffeeShopListPage.deleteAnyCoffeeShops(NEW_COFFEE_SHOP_NAME);
});

test('view coffee shops', async ({ page }) => {
    await new LandingPage(page).manageCoffeeShops();
});

test('edit coffee shop', async ({ page }) => {
    const coffeeShopName = "Epoch Coffee";
    let coffeeShopListPage = await new LandingPage(page).manageCoffeeShops();
    await expect(page).toHaveScreenshot("edit-before.png")
    let coffeeShopPage = await coffeeShopListPage.editCoffeeShop(coffeeShopName);

    const originalNumber = await coffeeShopPage.getField("phone");
    const updatedNumber = '123-456-7890';
    await coffeeShopPage.setField("phone", updatedNumber);
    coffeeShopListPage = await coffeeShopPage.save();
    await expect(page).toHaveScreenshot("edit-after.png")
    
    coffeeShopPage = await coffeeShopListPage.editCoffeeShop(coffeeShopName);
    expect(await coffeeShopPage.getField("phone")).toBe(updatedNumber)

    await coffeeShopPage.setField("phone", originalNumber);
    await coffeeShopPage.save();
});

test('add coffee shop', async ({ page }) => {
    let coffeeShopListPage = await new LandingPage(page).manageCoffeeShops();
    let coffeeShopPage = await coffeeShopListPage.addNewCoffeeShop();
    const newData: Map<CoffeeShopPageFieldName, string> = new Map();
    newData.set("name", NEW_COFFEE_SHOP_NAME);
    newData.set("phone", "555-123-4567");
    newData.set("address", '225 Main St., Central City');
    newData.set("priceOfCoffee", '3.14');
    newData.set("powerAccessible", 'true');
    newData.set("internetReliability", '4');
    for (let [key, value] of newData) {
        await coffeeShopPage.setField(key, value);
    }
    coffeeShopListPage = await coffeeShopPage.save();
    coffeeShopPage = await coffeeShopListPage.editCoffeeShop(NEW_COFFEE_SHOP_NAME);
    for (let [key, value] of newData) {
        expect(await coffeeShopPage.getField(key)).toBe(value);
    }
    await (await coffeeShopPage.cancel()).deleteCoffeeShop(NEW_COFFEE_SHOP_NAME);
});
