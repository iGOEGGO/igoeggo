describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});


describe('collapse options', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('show plot', function() {
    cy.get('button[id="button_plotting_show"]').click();
    //cy.get('button[id="plotting_mod2-plot"]').click();
    //cy.get('div[id="plotting_mod2-scatter_plot"]').click();
  });


  it('open options', function() {
    cy.get('div[id="plotting_mod1"]').find('button[data-widget="collapse"]').click();
    cy.get('div[id="plotting_mod1"]').find('.box-body').click();
  });

  it('close options', function() {
    cy.get('div[id="plotting_mod1"]').find('button[data-widget="collapse"]').click();
  });
});

describe('different datasets', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('scatterplot - mtcars', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod1-plot"]').click();
  });

  it('scatterplot - iris', function() {
    cy.get('a[href*="#shiny-tab-tab_transformation"]').click()
    
    cy.get('select[id="std"]').select('iris')

    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod2-plot"]').click();
    cy.get('div[id="plotting_mod2-scatter_plot"]').click();
  });
});

describe('scatterplot', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('scatterplot', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod1-plot"]').click();
  });

  it('second scatterplot', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod2-plot"]').click();
  });

  it('check scatterplots', function() {
    cy.get('select[id="plotting_mod1-scatter_x_var"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-scatter_x_var"]').children().should('contain', 'mpg');
  });

  it('delete scatterplots', function() {
    cy.get('button[id="plotting_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="plotting_mod2-delete_module"]').click({ force: true });
  });

  it('scatterplot with log x', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('input[id="plotting_mod3-logx"]').click({ force: true });
    cy.get('button[id="plotting_mod3-plot"]').click();
  });

  it('scatterplot with log y', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('input[id="plotting_mod4-logy"]').click({ force: true });
    cy.get('button[id="plotting_mod4-plot"]').click();
  });
    
  it('kategoriale variable', function() {
    //cy.get().find('div[data-value="Wählen Sie eine Spalte"]').click({force: true})
    cy.get('a[href*="#shiny-tab-tab_transformation"]').click()
    
    cy.get('select[id="cColumn"]').select('cyl')
    cy.get('select[id="cDatatype"]').select('factor')
    cy.get('button[id="changeDatatype"]').click();
    cy.wait(1000);
    cy.get('input[id="factors"]').type('6, 4, 8').should('have.value', '6, 4, 8');
    cy.get('input[id="factors"]').invoke('val', '6, 4, 8').should('have.value', '6, 4, 8');
    cy.get('button[id="ok"]').click({ force: true });
    cy.wait(1000);
    cy.get('tfoot', { timeout: 10000 }).children().should('contain','factor')

    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('div[data-value="Wählen Sie eine Spalte"]').should('have.length', 6);
  });

  it('scatterplot form', function() {
    cy.get('a[href*="#shiny-tab-tab_transformation"]').click()
    
    cy.get('tfoot', { timeout: 10000 }).children().should('contain','factor')

    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    //cy.get().find('div[data-value="Wählen Sie eine Spalte"]').click({force: true})
    cy.get('div[data-value="Wählen Sie eine Spalte"]').should('have.length', 6);
    cy.get('div[data-value="Wählen Sie eine Spalte"]').first().click({force: true})
    //cy.get('div[data-value="cyl"]').first().click({force: true})
  });
});

describe('mosaic', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('mosaic', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="mosaic"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click( {force: true}, { timeout: 10000 });
    cy.get('input[id="plotting_mod1-mosaic_vars-selectized"]').click({force: true})
    cy.get('div[data-value="mpg"]').click({force: true})
    cy.get('input[id="plotting_mod1-mosaic_vars-selectized"]').click({force: true})
    cy.get('div[id="plotting_mod1"]').find('.load-container').click({force: true})
    //cy.get('input[id="plotting_mod1-mosaic_plot"]').click({force: true})
    cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('second mosaic', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="mosaic"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 }), {force: true};
    cy.get('input[id="plotting_mod2-mosaic_vars-selectized"]').click({force: true})
    cy.get('div[id="plotting_mod2"]').find('div[data-value="mpg"]').click({force: true}, { multiple: true })
    cy.get('input[id="plotting_mod2-mosaic_vars-selectized"]').click({force: true})
    cy.get('div[id="plotting_mod2"]').find('.load-container').click({force: true})
    //cy.get('input[id="plotting_mod2-mosaic_plot"]').click({force: true})
    cy.get('button[id="plotting_mod2-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('check mosaics', function() {
    cy.get('select[id="plotting_mod1-mosaic_vars"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-mosaic_vars"]').children().should('contain', 'mpg');
  });

  it('delete mosaics', function() {
    cy.get('button[id="plotting_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="plotting_mod2-delete_module"]').click({ force: true });
  });
});

describe('haeufigkeiten', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('haeufigkeiten', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="haeufigkeiten"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 });
    cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('second haeufigkeiten', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="haeufigkeiten"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 });
    cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('check haeufigkeiten', function() {
    cy.get('select[id="plotting_mod1-kat"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-kat"]').children().should('contain', 'mpg');
  });

  it('delete haeufigkeiten', function() {
    cy.get('button[id="plotting_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="plotting_mod2-delete_module"]').click({ force: true });
  });

  it('haeufigkeiten piechart', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="haeufigkeiten"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 });
    cy.get('input[id="plotting_mod3-pie"]').click({ force: true });
    cy.get('button[id="plotting_mod3-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('haeufigkeiten percent', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="haeufigkeiten"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 });
    //cy.get('input[id="plotting_mod3-pie"]').click({ force: true });
    cy.get('input[name="plotting_mod4-mode"]').check("2", {force: true});
    cy.get('button[id="plotting_mod4-plot"]').click({ timeout: 10000 }, {force: true});
    cy.get('div[id="plotting_mod4-haeufigkeiten_plot"]').click();
  });

  it('haeufigkeiten relativ', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="haeufigkeiten"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 });
    //cy.get('input[id="plotting_mod3-pie"]').click({ force: true });
    cy.get('input[name="plotting_mod5-mode"]').check("3", {force: true});
    cy.get('button[id="plotting_mod5-plot"]').click({ timeout: 10000 }, {force: true});
    cy.get('div[id="plotting_mod5-haeufigkeiten_plot"]').click();
  });
});

describe('lineplot', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('lineplot', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="lineplot"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 }, {force: true} );
    cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('second lineplot', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="lineplot"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({ timeout: 10000 }, {force: true}) ;
    cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
  });

  it('check lineplots', function() {
    cy.get('select[id="plotting_mod1-y"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-y"]').children().should('contain', 'mpg');
  });

  it('delete lineplots', function() {
    cy.get('button[id="plotting_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="plotting_mod2-delete_module"]').click({ force: true });
  });
});
