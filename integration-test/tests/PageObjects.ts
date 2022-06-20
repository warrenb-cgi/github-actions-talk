import { expect, Page } from '@playwright/test';

abstract class PageObject {
    readonly page: Page;
    
    constructor(page: Page) {
        this.page = page;
    }

    protected async checkedNavigate<T extends PageObject, A>(pageObjectClass: CheckablePageObject<T, A>, arg: A) {
        await pageObjectClass.check(this.page, arg);
        return new pageObjectClass(this.page);
    }
}

type CheckablePageObject<T extends PageObject, A> = { check(p: Page, arg: A): Promise<void> } & (new (p: Page) => T);

class LandingPage extends PageObject {
    async manageCoffeeShops() {
        await Promise.all([
            this.page.waitForNavigation(),
            this.page.locator('text="Manage Coffee Shops"').click()
        ]);
        return this.checkedNavigate(CoffeeShopListPage, []);
    }
}

class CoffeeShopListPage extends PageObject {

    static async check(page: Page) {
        await expect(page.locator(".coffee-shops-title")).toBeDefined();
    }

    async addNewCoffeeShop() {
        await this.page.locator('a:text("Add New")').click();
        return this.checkedNavigate(CoffeeShopPage, "");
    }

    private coffeeShopTileLocator(name: string) {
        return this.page.locator(`.coffeeshop-container :text("${name}") >> xpath=..`);
    }

    async editCoffeeShop(name: string) {
        await Promise.all([
            this.page.waitForNavigation(),
            this.coffeeShopTileLocator(name).locator('a:text("Edit")').click()
        ]);
        return this.checkedNavigate(CoffeeShopPage, name);
    }

    async deleteCoffeeShop(name: string) {
        return this.coffeeShopTileLocator(name).locator('text="Delete"').click();
    }

    async deleteAnyCoffeeShops(name: string) {
        const shops = this.coffeeShopTileLocator(name);
        const count = await shops.count()
        const deletePromises = [];
        for (let i = 0; i < count; ++i) {
            deletePromises.push(shops.nth(i).locator('text="Delete"').click())
        }
        return Promise.all(deletePromises);
    }
}

type CoffeeShopPageFieldName = "name" | "phone" | "address" | "priceOfCoffee" | "powerAccessible" | "internetReliability";

class CoffeeShopPage extends PageObject {

    private static isSelect(fieldName: CoffeeShopPageFieldName) {
        return fieldName == "internetReliability" || fieldName == "powerAccessible";
    }

    private static fieldLocator(page: Page, fieldName: CoffeeShopPageFieldName) {
        const elementType = this.isSelect(fieldName) ? "select" : "input";
        return page.locator(`${elementType}[name="${fieldName}"]`);
    }

    static async check(page: Page, name: string) {
        await expect(this.fieldLocator(page, "name")).toHaveValue(name);
    }

    async getField(fieldName: CoffeeShopPageFieldName) {
        return CoffeeShopPage.fieldLocator(this.page, fieldName).inputValue();
    }

    async setField(fieldName: CoffeeShopPageFieldName, value: string) {
        const locator = CoffeeShopPage.fieldLocator(this.page, fieldName)
        if (CoffeeShopPage.isSelect(fieldName)) {
            return locator.selectOption(value);
        } else {
            return locator.fill(value);
        }
    }

    async save() {
        await Promise.all([
            this.page.waitForNavigation(),
            this.page.locator('text=Save').click()
        ]);
        return this.checkedNavigate(CoffeeShopListPage, []);
    }

    async cancel() {
        await Promise.all([
            this.page.waitForNavigation(),
            this.page.locator('text=Cancel').click()
        ]);
        return this.checkedNavigate(CoffeeShopListPage, []);
    }

    async home() {
        await this.page.locator('text="Home"').click()
        return new LandingPage(this.page);
    }
}

export {LandingPage, CoffeeShopListPage, CoffeeShopPage, CoffeeShopPageFieldName};
