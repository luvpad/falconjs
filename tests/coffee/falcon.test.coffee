describe "Falcon", ->
	describe "cacheTemplates", ->
		template = document.createElement("template")
		template.setAttribute("id", "test_template_1")
		template.innerHTML = "Hello World 1"

		template2 = document.createElement("template")
		template2.setAttribute("id", "test_template_2")
		template2.innerHTML = "Hello World 2"

		beforeEach ->
			document.body.appendChild( template )
			document.body.appendChild( template2 )

			spyOn( Falcon.View, 'cacheTemplate' )
		#END beforeEach

		it "Should have removed and cached the templates", ->
			templates = document.querySelectorAll("template")
			expect( templates.length ).toBe( 2 )
			
			ret = Falcon.cacheTemplates()
			
			templates = document.querySelectorAll("template")
			expect( templates.length ).toBe( 0 )

			expect( Falcon.View.cacheTemplate.calls.count() ).toBe( 2 )
			expect( Falcon.View.cacheTemplate.calls.argsFor(0) ).toEqual [
				'#test_template_1'
				'Hello World 1'
			]

			expect( Falcon.View.cacheTemplate.calls.argsFor(1) ).toEqual [
				'#test_template_2'
				'Hello World 2'
			]

			expect( ret ).toBe( Falcon )
		#END it
	#END describe
	
	describe "apply", ->
		view = null
		
		beforeEach ->
			spyOn( ko, 'applyBindings' )
			view = new Falcon.View
			observable_view = ko.observable(view)
		#END beforeEach

		it "Should find the correct element with an HTMLElement", ->
			element = document.createElement("div")
			document.body.appendChild( element )
			callback = jasmine.createSpy("Callback")

			ret = Falcon.apply(view, element, callback)

			expect( ko.applyBindings.calls.count() ).toBe( 1 )
			expect( ko.applyBindings ).toHaveBeenCalledWith(jasmine.any(Function), element)

			observable = ko.applyBindings.calls.mostRecent().args[0]
			expect( ko.isObservable(observable) ).toBe( true )
			expect( observable() ).toBe( view )

			expect( callback.calls.count() ).toBe( 1 )

			expect( ret ).toBe( Falcon )

			document.body.removeChild( element )
		#END it

		it "Should find the correct element by id", ->
			element = document.createElement("div")
			element.setAttribute("id","test")
			document.body.appendChild( element )
			callback = jasmine.createSpy("Callback")

			ret = Falcon.apply(view, "#test", callback)

			expect( ko.applyBindings.calls.count() ).toBe( 1 )
			expect( ko.applyBindings ).toHaveBeenCalledWith(jasmine.any(Function), element)

			observable = ko.applyBindings.calls.mostRecent().args[0]
			expect( ko.isObservable(observable) ).toBe( true )
			expect( observable() ).toBe( view )

			expect( callback.calls.count() ).toBe( 1 )

			expect( ret ).toBe( Falcon )

			document.body.removeChild( element )
		#END it

		it "Should find the correct element using Falcon.applicationElement", ->
			element = document.createElement("div")
			document.body.appendChild( element )
			Falcon.applicationElement = element
			callback = jasmine.createSpy("Callback")

			ret = Falcon.apply(view, callback)

			expect( ko.applyBindings.calls.count() ).toBe( 1 )
			expect( ko.applyBindings ).toHaveBeenCalledWith(jasmine.any(Function), element)

			observable = ko.applyBindings.calls.mostRecent().args[0]
			expect( ko.isObservable(observable) ).toBe( true )
			expect( observable() ).toBe( view )

			expect( callback.calls.count() ).toBe( 1 )

			expect( ret ).toBe( Falcon )

			document.body.removeChild( element )
		#END it

		it "Should find the correct element by id us Falcon.applicationElement", ->
			element = document.createElement("div")
			element.setAttribute("id","test")
			document.body.appendChild( element )
			Falcon.applicationElement = "#test"
			callback = jasmine.createSpy("Callback")

			ret = Falcon.apply(view, callback)

			expect( ko.applyBindings.calls.count() ).toBe( 1 )
			expect( ko.applyBindings ).toHaveBeenCalledWith(jasmine.any(Function), element)

			observable = ko.applyBindings.calls.mostRecent().args[0]
			expect( ko.isObservable(observable) ).toBe( true )
			expect( observable() ).toBe( view )

			expect( callback.calls.count() ).toBe( 1 )

			expect( ret ).toBe( Falcon )

			document.body.removeChild( element )
		#END it
	#END describe

	describe "isModel", ->
		it "Should correctly identify a model", ->
			expect( Falcon.isModel( new Falcon.Model ) ).toBe( true )
			expect( Falcon.isModel( new Falcon.Collection ) ).toBe( false )
			expect( Falcon.isModel( new Falcon.View ) ).toBe( false )
			expect( Falcon.isModel( 123 ) ).toBe( false )
			expect( Falcon.isModel() ).toBe( false )
		#END it
	#END describe

	describe "isCollection", ->
		it "Should correctly identify a collection", ->
			expect( Falcon.isCollection( new Falcon.Model ) ).toBe( false )
			expect( Falcon.isCollection( new Falcon.Collection ) ).toBe( true )
			expect( Falcon.isCollection( new Falcon.View ) ).toBe( false )
			expect( Falcon.isCollection( 123 ) ).toBe( false )
			expect( Falcon.isCollection() ).toBe( false )
		#END it
	#END describe

	describe "isView", ->
		it "Should correctly identify a view", ->
			expect( Falcon.isView( new Falcon.Model ) ).toBe( false )
			expect( Falcon.isView( new Falcon.Collection ) ).toBe( false )
			expect( Falcon.isView( new Falcon.View ) ).toBe( true )
			expect( Falcon.isView( 123 ) ).toBe( false )
			expect( Falcon.isView() ).toBe( false )
		#END it
	#END describe

	describe "isDataObject", ->
		it "Should correctly identify a data object", ->
			expect( Falcon.isDataObject( new Falcon.Model ) ).toBe( true )
			expect( Falcon.isDataObject( new Falcon.Collection ) ).toBe( true )
			expect( Falcon.isDataObject( new Falcon.View ) ).toBe( false )
			expect( Falcon.isDataObject( 123 ) ).toBe( false )
			expect( Falcon.isDataObject() ).toBe( false )
		#END it
	#END describe

	describe "isFalconObject", ->
		it "Should correctly identify a falcon related object", ->
			expect( Falcon.isFalconObject( new Falcon.Model ) ).toBe( true )
			expect( Falcon.isFalconObject( new Falcon.Collection ) ).toBe( true )
			expect( Falcon.isFalconObject( new Falcon.View ) ).toBe( true )
			expect( Falcon.isFalconObject( 123 ) ).toBe( false )
			expect( Falcon.isFalconObject() ).toBe( false )
		#END it
	#END describe

	describe "addBinding", ->
		it "Should add a binding properly", ->
			expect( ko.bindingHandlers['new_binding'] ).not.toBeDefined()
			expect( ko.virtualElements.allowedBindings['new_binding'] ).not.toBeDefined()
			definition = {init: (->), update: (->)}

			ret = Falcon.addBinding("new_binding", definition)
			expect( ko.bindingHandlers['new_binding'] ).toBe( definition )
			expect( ko.virtualElements.allowedBindings['new_binding'] ).not.toBeDefined()

			expect( ret ).toBe( definition )
		#END it

		it "Should allow for a function argument", ->
			expect( ko.bindingHandlers['new_binding2'] ).not.toBeDefined()
			expect( ko.virtualElements.allowedBindings['new_binding2'] ).not.toBeDefined()
			method = (->)

			ret = Falcon.addBinding("new_binding2", method)
			expect( ko.bindingHandlers['new_binding2'] ).toEqual({update: method})
			expect( ko.virtualElements.allowedBindings['new_binding2'] ).not.toBeDefined()

			expect( ret ).toEqual({update: method})
		#END it

		it "Should allow for virtual bindings", ->
			expect( ko.bindingHandlers['new_binding3'] ).not.toBeDefined()
			expect( ko.virtualElements.allowedBindings['new_binding3'] ).not.toBeDefined()
			definition = {init: (->), update: (->)}

			ret = Falcon.addBinding("new_binding3", true, definition)
			expect( ko.bindingHandlers['new_binding3'] ).toBe( definition )
			expect( ko.virtualElements.allowedBindings['new_binding3'] ).toBe( true )

			expect( ret ).toBe( definition )
		#END it

		it "Should allow for virtual bindings with a function argument", ->
			expect( ko.bindingHandlers['new_binding4'] ).not.toBeDefined()
			expect( ko.virtualElements.allowedBindings['new_binding4'] ).not.toBeDefined()
			method = (->)

			ret = Falcon.addBinding("new_binding4", true, method)
			expect( ko.bindingHandlers['new_binding4'] ).toEqual({update: method})
			expect( ko.virtualElements.allowedBindings['new_binding4'] ).toBe( true )

			expect( ret ).toEqual({update: method})
		#END it
	#END describe

	describe "getBinding", ->
		it "Should fetch a valid binding", ->
			expect( Falcon.getBinding('foreach') ).toBe( ko.bindingHandlers['foreach'] )
		#END it
	#END describe
#END describe