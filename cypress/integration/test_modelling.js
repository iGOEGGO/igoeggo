describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

//tests besser aufteilen -> waiting-Funktionalitaet
describe('linear', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_modelle"]').click()
    cy.get('select[id="select_plotting_model"]').children().should('contain', 'Linear');
  });

  it('linear', function() {
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod1-create_model"]').click({ force: true });
    cy.get('div[id="model_mod1-linear_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('second linear', function() {
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod2-create_model"]').click({ force: true });
    cy.get('div[id="model_mod2-linear_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('check linear', function() {
    cy.get('div[id="model_mod1-linear_formel"]').should('contain', 'Regression');
    cy.get('div[id="model_mod2-linear_formel"]').should('contain', 'Regression');
  });

  it('delete linear', function() {
    cy.get('button[id="model_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="model_mod2-delete_module"]').click({ force: true });
  });
});

describe('nonlinear', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_modelle"]').click()
    cy.get('select[id="select_plotting_model"]').children().should('contain', 'Linear');
  });

  it('nonlinear', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="nonlinear"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod1-create_nonlinear_model"]').click({ force: true }, { timeout: 10000 });
    cy.get('div[id="model_mod1-nonlinear_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('second nonlinear', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="nonlinear"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod2-create_nonlinear_model"]').click({ force: true }, { timeout: 10000 });
    cy.get('div[id="model_mod2-nonlinear_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('check nonlinears', function() {
    cy.get('div[id="model_mod1-nonlinear_formel"]').should('contain', 'Regression');
    cy.get('div[id="model_mod2-nonlinear_formel"]').should('contain', 'Regression');
  });

  it('delete nonlinears', function() {
    cy.get('button[id="model_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="model_mod2-delete_module"]').click({ force: true });
  });
});

describe('exp', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_modelle"]').click()
    cy.get('select[id="select_plotting_model"]').children().should('contain', 'Linear');
  });

  it('exp', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="exp"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod1-create_exponential_model"]').click({ force: true });
    cy.get('div[id="model_mod1-exponential_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('second exp', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="exp"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod2-create_exponential_model"]').click({ force: true });
    cy.get('div[id="model_mod2-exponential_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('check exps', function() {
    cy.get('div[id="model_mod1-exponential_formel"]').should('contain', 'Regression');
    cy.get('div[id="model_mod2-exponential_formel"]').should('contain', 'Regression');
  });

  it('delete exps', function() {
    cy.get('button[id="model_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="model_mod2-delete_module"]').click({ force: true });
  });
});

describe('log', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_modelle"]').click()
    cy.get('select[id="select_plotting_model"]').children().should('contain', 'Linear');
  });

  it('log', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="log"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod1-create_log_model"]').click({ force: true });
    cy.get('div[id="model_mod1-log_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('second log', function() {
    cy.get('div[data-value="linear"]').click({force: true})
    cy.get('div[data-value="log"]').click({force: true})
    cy.get('button[id="button_model_show"]').click({ force: true });
    cy.get('button[id="model_mod2-create_log_model"]').click({ force: true });
    cy.get('div[id="model_mod2-log_formel"]').should('contain', 'Regression', { timeout: 10000 });
  });

  it('check logs', function() {
    cy.get('div[id="model_mod1-log_formel"]').should('contain', 'Regression');
    cy.get('div[id="model_mod2-log_formel"]').should('contain', 'Regression');
  });

  it('delete logs', function() {
    cy.get('button[id="model_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="model_mod2-delete_module"]').click({ force: true });
  });
});
 
