const url = '127.0.0.1:8080'
//const url = 'http://igoeggo.herokuapp.com'

describe('testselect', function() {
  before(function() {
    cy.visit(url);
	
    // log in only once before any of the tests run.
    // your app will likely set some sort of session cookie.
    // you'll need to know the name of the cookie(s), which you can find
    // in your Resources -> Cookies panel in the Chrome Dev Tools.
    //cy.login()
  });
  
  beforeEach(() => {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is an example
    Cypress.Cookies.preserveOnce('JSESSIONID')
  })
  
  //selectize-Auswahl moeglich
  it('login possible', function() {
      cy.get('input[id="username"]').should('exist');
      cy.get('input[id="password"]').should('exist');
  });

  it('login', function() {
    cy.get('input[id="username"]').type('tim');
    cy.get('input[id="password"]').type('passtim');
    //cy.get('input[id="password"]').type('{enter}')
    cy.get('form').submit();
  });

  it('open app', function() {
    cy.get('a[href="/app/iGOEGGO"]').click();
    cy.get('iframe[id="shinyframe"]', { timeout: 20000 }).should('exist');
    cy.wait(20000);
  });
});

describe('check container 1', function() {
  before(function() {
    cy.visit('http://127.0.0.1:20000')
	
    // log in only once before any of the tests run.
    // your app will likely set some sort of session cookie.
    // you'll need to know the name of the cookie(s), which you can find
    // in your Resources -> Cookies panel in the Chrome Dev Tools.
    //cy.login()
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('testselect', function() {
  before(function() {
    cy.visit(url+"/login");
	
    // log in only once before any of the tests run.
    // your app will likely set some sort of session cookie.
    // you'll need to know the name of the cookie(s), which you can find
    // in your Resources -> Cookies panel in the Chrome Dev Tools.
    //cy.login()
  });
  
  beforeEach(() => {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is an example
    Cypress.Cookies.preserveOnce('JSESSIONID')
  })
  
  //selectize-Auswahl moeglich
  it('login possible', function() {
      cy.get('input[id="username"]').should('exist');
      cy.get('input[id="password"]').should('exist');
  });

  it('login', function() {
    cy.get('input[id="username"]').type('jan');
    cy.get('input[id="password"]').type('passjan');
    //cy.get('input[id="password"]').type('{enter}')
    cy.get('form').submit();
  });

  it('open app', function() {
    cy.get('a[href="/app/iGOEGGO"]').click();
    cy.get('iframe[id="shinyframe"]', { timeout: 20000 }).should('exist');
    cy.wait(20000);
  });
});

describe('check container 2', function() {
  before(function() {
    cy.visit('http://127.0.0.1:20001')
	
    // log in only once before any of the tests run.
    // your app will likely set some sort of session cookie.
    // you'll need to know the name of the cookie(s), which you can find
    // in your Resources -> Cookies panel in the Chrome Dev Tools.
    //cy.login()
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});
