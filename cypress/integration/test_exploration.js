describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('boxplot', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    cy.get('select[id="select_exploration_option"]').children().should('contain', 'Boxplot');
  });

  it('boxplot', function() {
    cy.get('button[id="button_exploration_show"]').click();
    cy.get('button[id="exploration_mod1-plot"]').click();
  });

  it('second boxplot', function() {
    cy.get('button[id="button_exploration_show"]').click();
    //cy.get('input[id="exploration_mod2-mean_line"]').click({ force: true });
    cy.get('button[id="exploration_mod2-plot"]').click();
  });

  it('check boxplots', function() {
    cy.get('select[id="exploration_mod1-box_var"]').children().should('contain', 'mpg');
    cy.get('select[id="exploration_mod2-box_var"]').children().should('contain', 'mpg');
  });

  it('delete boxplots', function() {
    cy.get('button[id="exploration_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="exploration_mod2-delete_module"]').click({ force: true });
  });

  //line on the mean-value
  it('boxplot with mean', function() {
    cy.get('button[id="button_exploration_show"]').click();
    cy.get('input[id="exploration_mod3-mean_line"]').click({ force: true });
    cy.get('button[id="exploration_mod3-plot"]').click();
    cy.get('div[id="exploration_mod3-box_plot"]').click();
  });
});


describe('histogram', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    cy.get('select[id="select_exploration_option"]').children().should('contain', 'Boxplot');
  });

  it('histogram', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="hist"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('button[id="exploration_mod1-plot"]').click({ force: true });
  });

  it('second histogram', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="hist"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('button[id="exploration_mod2-plot"]').click({ force: true });
  });

  it('check histograms', function() {
    cy.get('select[id="exploration_mod1-hist_var"]').children().should('contain', 'mpg');
    cy.get('select[id="exploration_mod2-hist_var"]').children().should('contain', 'mpg');
  });

  it('delete histograms', function() {
    cy.get('button[id="exploration_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="exploration_mod2-delete_module"]').click({ force: true });
  });

  it('histogram with bin', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="hist"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('button[id="exploration_mod3-plot"]').click({ force: true });
    cy.get('input[id="exploration_mod3-bin_count"]').click({ force: true });
    cy.get('input[id="exploration_mod3-bin_count"]').then(elem => {
      elem.val(4);
    }, { force: true });
    //cy.get('input[id="exploration_mod3-bin_count"]').invoke('data-shinyjs-resettable-value', 4);
    cy.get('button[id="exploration_mod3-plot"]').click({ force: true });
    cy.get('div[id="exploration_mod3-hist_plot"]').click({ force: true });
  });

  //line on the mean-value
  it('histogram with mean', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="hist"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('input[id="exploration_mod4-mean_line"]').click({ force: true });
    cy.get('button[id="exploration_mod4-plot"]').click({ force: true });
    cy.get('div[id="exploration_mod4-hist_plot"]').click({ force: true });
  });
});


describe('four plot', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    cy.get('select[id="select_exploration_option"]').children().should('contain', 'Boxplot');
  });

  it('fpv', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="four_plot_view"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({force: true});
    cy.get('button[id="exploration_mod1-plot"]').click({force: true});
  });

  it('second fpv', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="four_plot_view"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({force: true});
    cy.get('button[id="exploration_mod2-plot"]').click({force: true});
  });

  it('check fpvs', function() {
    cy.get('select[id="exploration_mod1-fp_var"]').children().should('contain', 'mpg');
    cy.get('select[id="exploration_mod2-fp_var"]').children().should('contain', 'mpg');
  });

  it('delete fpvs', function() {
    cy.get('button[id="exploration_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="exploration_mod2-delete_module"]').click({ force: true });
  });
});

describe('qq', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    cy.get('select[id="select_exploration_option"]').children().should('contain', 'Boxplot');
  });

  it('qq', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="qq"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('button[id="exploration_mod1-plot"]').click({ force: true });
  });

  it('second qq', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="qq"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click({ force: true });
    cy.get('button[id="exploration_mod2-plot"]').click({ force: true });
  });

  it('check qqs', function() {
    cy.get('select[id="exploration_mod1-qq_var"]').children().should('contain', 'mpg');
    cy.get('select[id="exploration_mod2-qq_var"]').children().should('contain', 'mpg');
  });

  it('delete qqs', function() {
    cy.get('button[id="exploration_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="exploration_mod2-delete_module"]').click({ force: true });
  });
});

describe('ecdf', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    cy.get('select[id="select_exploration_option"]').children().should('contain', 'Boxplot');
  });

  it('ecdf', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="ecdf"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click();
    cy.get('button[id="exploration_mod1-plot"]').click();
  });

  it('second ecdf', function() {
    cy.get('div[data-value="boxplot"]').click({force: true})
    cy.get('div[data-value="ecdf"]').click({force: true})
    cy.get('button[id="button_exploration_show"]').click();
    cy.get('button[id="exploration_mod2-plot"]').click();
  });

  it('check ecdfs', function() {
    cy.get('select[id="exploration_mod1-ecdf_var"]').children().should('contain', 'mpg');
    cy.get('select[id="exploration_mod2-ecdf_var"]').children().should('contain', 'mpg');
  });

  it('delete ecdfs', function() {
    cy.get('button[id="exploration_mod1-delete_module"]').click({ force: true });
    cy.get('button[id="exploration_mod2-delete_module"]').click({ force: true });
  });
});