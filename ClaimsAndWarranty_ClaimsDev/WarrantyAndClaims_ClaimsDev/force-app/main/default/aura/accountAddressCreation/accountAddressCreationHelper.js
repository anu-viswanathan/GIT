({
    // borrowed from here: http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#JavaScript
    /*
      Copyright (c) 2011 Andrei Mackenzie
    
      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    
      The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    */
    getEditDistance : function(a, b) {
        if (a.length === 0) return b.length;
        if (b.length === 0) return a.length;
        
        var matrix = [];
        
        var i;
        for (i = 0; i <= b.length; i++) {
            matrix[i] = [i];
        }
        
        var j;
        for (j = 0; j <= a.length; j++) {
            matrix[0][j] = j;
        }
        
        for (i = 1; i <= b.length; i++) {
            for (j = 1; j <= a.length; j++) {
                if (b.charAt(i-1) == a.charAt(j-1)) {
                    matrix[i][j] = matrix[i-1][j-1];
                } else {
                    matrix[i][j] = Math.min(matrix[i-1][j-1] + 1,
                                            Math.min(matrix[i][j-1] + 1,
                                                     matrix[i-1][j] + 1));
                }
            }
        }
        
        return matrix[b.length][a.length];
    },
    getJSON : function(component, req, callback) {
        var action = component.get("c.getResponse");
        action.setParams({ request : 'GlobalExpressFreeForm?' + req });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(JSON.parse(response.getReturnValue()));
            } else if (state === "INCOMPLETE") {
                console.log("Listware: Incomplete action");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})