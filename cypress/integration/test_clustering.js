describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('clustering - k', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_cluster"]').click()
    cy.get('select[id="select_plotting_cluster"]').children().should('contain', 'cluster');
  });

  it('cluster', function() {
    cy.get('button[id="button_cluster_show"]').click({ force: true });
    cy.get('button[id="cluster_mod1-create_cluster"]').click({ force: true });
  });

  it('second cluster', function() {
    cy.get('button[id="button_cluster_show"]').click({ force: true });
    cy.get('button[id="cluster_mod2-create_cluster"]').click({ force: true });
  });

  it('check cluster', function() {
    cy.get('div[id="cluster_mod1-cluster"]').find('svg', { timeout: 10000 });
    cy.get('div[id="cluster_mod2-cluster"]').find('svg'), { timeout: 10000 };
  });

  it('delete cluster', function() {
    cy.get('button[id="cluster_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="cluster_mod2-delete_module"]').click({ force: true });
  });
});

describe('clustering - analyse', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_cluster"]').click()
    cy.get('select[id="select_plotting_cluster"]').children().should('contain', 'cluster');
  });

  it('analyse', function() {
    cy.get('div[data-value="cluster"]').click({force: true})
    cy.get('div[data-value="analysis"]').click({force: true})
    cy.get('button[id="button_cluster_show"]').click({ force: true });
    cy.get('button[id="cluster_mod1-create_cluster_analysis"]').click({ force: true });
  });

  it('second analyse', function() {
    cy.get('button[id="button_cluster_show"]').click({ force: true });
    cy.get('button[id="cluster_mod2-create_cluster_analysis"]').click({ force: true });
  });

  it('check analyse', function() {
    cy.get('div[id="cluster_mod1-cluster_analysis_1"]').find('img', { timeout: 10000 });
    cy.get('div[id="cluster_mod2-cluster_analysis_2"]').find('img', { timeout: 10000 });
    cy.get('div[id="cluster_mod2-cluster_analysis_1"]').find('img', { timeout: 10000 });
    cy.get('div[id="cluster_mod2-cluster_analysis_2"]').find('img'), { timeout: 10000 };
  });

  it('delete analyse', function() {
    cy.get('button[id="cluster_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="cluster_mod2-delete_module"]').click({ force: true });
  });
});
 
