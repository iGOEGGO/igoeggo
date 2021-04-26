describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('select', function() {
  before(function() {
    cy.visit("/");
  });

  it('select', function() {
    /*cy.get('div[data-value="select"]').click({force: true})
    cy.get('div[data-value="select"]').click({force: true})*/
    cy.get('[id="user_input"]').type('mpg, cyl, disp');
    cy.get('[id="apply_operation"]').click();
  });

  it('check select', function() {
    cy.get('div[id="testtable"]').contains('th','am', { timeout: 10000 }).should('not.exist');
  });
});

describe('filter', function() {
  before(function() {
    cy.visit("/");
  });

  it('filter', function() {
    cy.get('div[data-value="select"]').click({force: true})
    cy.get('div[data-value="filter"]').click({force: true})
    cy.get('[id="user_input"]').type('mpg>21',{force: true}).should('have.value', 'mpg>21');
    cy.get('[id="apply_operation"]').click();
  });

  it('check filter', function() {
    cy.get('div[class="dataTables_info"', { timeout: 10000 }).should('contain','of 12 entries', { timeout: 10000 });
  });
});

describe('mutate', function() {
  before(function() {
    cy.visit("/");
  });

  it('mutate', function() {
    cy.get('div[data-value="select"]').click({force: true})
    cy.get('div[data-value="mutate"]').click({force: true})
    cy.get('[id="user_input"]').type('lp100km_one_line = 100/((mpg*1.609)/3.785)');
    cy.get('[id="apply_operation"]').click();
  });

  it('check mutate', function() {
    //cy.get('div[class="dataTables_info"', { timeout: 10000 }).should('contain','lp100km_one_line', { timeout: 10000 });
    cy.get('div[id="testtable"]').contains('th','lp100km_one_line', { timeout: 10000 });
  });
});

describe('reset dataset', function() {
  before(function() {
    cy.visit("/");
  });

  it('select', function() {
    /*cy.get('div[data-value="select"]').click({force: true})
    cy.get('div[data-value="select"]').click({force: true})*/
    cy.get('[id="user_input"]').type('mpg, cyl, disp');
    cy.get('[id="apply_operation"]').click();
  });

  it('check select', function() {
    cy.get('div[id="testtable"]').contains('th','am', { timeout: 10000 }).should('not.exist');
  });

  it('reset', function() {
    cy.get('button[id="revert_to_root"]').click({force: true})
  });


  it('check reset', function() {
    cy.get('div[id="testtable"]').contains('th','am', { timeout: 10000 });
  });
});
