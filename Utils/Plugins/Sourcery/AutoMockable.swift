import Foundation

extension SourceryBuildToolPlugin {
    var AutoMockable: Template {
        .init(
            name: "AutoMockable",
            content: """
            // swiftlint:disable line_length
            // swiftlint:disable variable_name

            import Foundation
            #if os(iOS) || os(tvOS) || os(watchOS)
            import UIKit
            #elseif os(OSX)
            import AppKit
            #endif

            {% for import in argument.Library %}
            import {{ import }}
            {% endfor %}

            {% for import in argument.Target %}
            @testable import {{ import }}
            {% endfor %}

            {% macro swiftifyMethodName name %}{{ name | replace:"(","_" | replace:")","" | replace:":","_" | replace:"`","" | snakeToCamelCase | lowerFirstWord }}{% endmacro %}

            {% macro accessLevel level %}{% if level != 'internal' %}{{ level }} {% endif %}{% endmacro %}

            {% macro staticSpecifier method %}{% if method.isStatic and not method.isInitializer %}static {% endif %}{% endmacro %}

            {% macro methodThrowableErrorDeclaration method %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}ThrowableError: Error?
            {% endmacro %}

            {% macro methodThrowableErrorUsage method %}
                    if let error = {% call swiftifyMethodName method.selectorName %}ThrowableError {
                        throw error
                    }
            {% endmacro %}

            {% macro methodReceivedParameters method %}
                {% set hasNonEscapingClosures %}
                    {%- for param in method.parameters where param.isClosure and not param.typeAttributes.escaping %}
                        {{ true }}
                    {% endfor -%}
                {% endset %}
                {% if method.parameters.count == 1 and not hasNonEscapingClosures %}
                    {% call swiftifyMethodName method.selectorName %}Received{% for param in method.parameters %}{{ param.name|upperFirstLetter }} = {{ param.name }}{% endfor %}
                    {% call swiftifyMethodName method.selectorName %}ReceivedInvocations.append({% for param in method.parameters %}{{ param.name }}){% endfor %}
                {% else %}
                {% if not method.parameters.count == 0 and not hasNonEscapingClosures %}
                    {% call swiftifyMethodName method.selectorName %}ReceivedArguments = ({% for param in method.parameters %}{{ param.name }}: {{ param.name }}{% if not forloop.last%}, {% endif %}{% endfor %})
                    {% call swiftifyMethodName method.selectorName %}ReceivedInvocations.append(({% for param in method.parameters %}{{ param.name }}: {{ param.name }}{% if not forloop.last%}, {% endif %}{% endfor %}))
                {% endif %}
                {% endif %}
            {% endmacro %}

            {% macro methodClosureName method %}{% call swiftifyMethodName method.selectorName %}Closure{% endmacro %}

            {% macro closureReturnTypeName method %}{% if method.isOptionalReturnType %}{{ method.unwrappedReturnTypeName }}?{% else %}{{ method.returnTypeName }}{% endif %}{% endmacro %}

            {% macro methodClosureDeclaration method %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call methodClosureName method %}: (({% for param in method.parameters %}{% call existentialClosureVariableTypeName param.typeName %}{% if not forloop.last %}, {% endif %}{% endfor %}) {% if method.isAsync %}async {% endif %}{% if method.throws %}throws {% endif %}-> {% if method.isInitializer %}Void{% else %}{% call closureReturnTypeName method %}{% endif %})?
            {% endmacro %}

            {% macro methodClosureCallParameters method %}{% for param in method.parameters %}{{ param.name }}{% if not forloop.last %}, {% endif %}{% endfor %}{% endmacro %}

            {% macro mockMethod method %}
                //MARK: - {{ method.shortName }}

                {% if method.throws %}
                    {% call methodThrowableErrorDeclaration method %}
                {% endif %}
                {% if not method.isInitializer %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}CallsCount = 0
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}Called: Bool {
                    return {% call swiftifyMethodName method.selectorName %}CallsCount > 0
                }
                {% endif %}
                {% set hasNonEscapingClosures %}
                    {%- for param in method.parameters where param.isClosure and not param.typeAttributes.escaping %}
                        {{ true }}
                    {% endfor -%}
                {% endset %}
                {% if method.parameters.count == 1 and not hasNonEscapingClosures %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}Received{% for param in method.parameters %}{{ param.name|upperFirstLetter }}: {{ '(' if param.isClosure }}({% call existentialClosureVariableTypeName param.typeName.unwrappedTypeName %}{{ ')' if param.isClosure }})?{% endfor %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}ReceivedInvocations{% for param in method.parameters %}: [{{ '(' if param.isClosure }}({% call existentialClosureVariableTypeName param.typeName.unwrappedTypeName %}){{ ')' if param.isClosure }}{%if param.typeName.isOptional%}?{%endif%}]{% endfor %} = []
                {% elif not method.parameters.count == 0 and not hasNonEscapingClosures %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}ReceivedArguments: ({% for param in method.parameters %}{{ param.name }}: {% if param.typeAttributes.escaping %}{% call existentialClosureVariableTypeName param.typeName.unwrappedTypeName %}{% else %}{% call existentialClosureVariableTypeName param.typeName %}{% endif %}{{ ', ' if not forloop.last }}{% endfor %})?
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}ReceivedInvocations: [({% for param in method.parameters %}{{ param.name }}: {% if param.typeAttributes.escaping %}{% call existentialClosureVariableTypeName param.typeName.unwrappedTypeName %}{% else %}{% call existentialClosureVariableTypeName param.typeName %}{% endif %}{{ ', ' if not forloop.last }}{% endfor %})] = []
                {% endif %}
                {% if not method.returnTypeName.isVoid and not method.isInitializer %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}var {% call swiftifyMethodName method.selectorName %}ReturnValue: {{ '(' if method.returnTypeName.isClosure and not method.isOptionalReturnType }}{{ method.returnTypeName }}{{ ')' if method.returnTypeName.isClosure and not method.isOptionalReturnType }}{{ '!' if not method.isOptionalReturnType }}
                {% endif %}
                {% call methodClosureDeclaration method %}

            {% if method.isInitializer %}
                {% call accessLevel method.accessLevel %}required {{ method.name }} {
                    {% call methodReceivedParameters method %}
                    {% call methodClosureName method %}?({% call methodClosureCallParameters method %})
                }
            {% else %}
                {% for name, attribute in method.attributes %}
                {% for value in attribute %}
                {{ value }}
                {% endfor %}
                {% endfor %}
                {% call accessLevel method.accessLevel %}{% call staticSpecifier method %}{% call methodName method %}{{ ' async' if method.isAsync }}{{ ' throws' if method.throws }}{% if not method.returnTypeName.isVoid %} -> {{ method.returnTypeName }}{% endif %} {
                    {% if method.throws %}
                    {% call methodThrowableErrorUsage method %}
                    {% endif %}
                    {% call swiftifyMethodName method.selectorName %}CallsCount += 1
                    {% call methodReceivedParameters method %}
                    {% if method.returnTypeName.isVoid %}
                    {% if method.throws %}try {% endif %}{% if method.isAsync %}await {% endif %}{% call methodClosureName method %}?({% call methodClosureCallParameters method %})
                    {% else %}
                    if let {% call methodClosureName method %} = {% call methodClosureName method %} {
                        return {{ 'try ' if method.throws }}{{ 'await ' if method.isAsync }}{% call methodClosureName method %}({% call methodClosureCallParameters method %})
                    } else {
                        return {% call swiftifyMethodName method.selectorName %}ReturnValue
                    }
                    {% endif %}
                }

            {% endif %}
            {% endmacro %}

            {% macro resetMethod method %}
                    {# for type method which are mocked, a way to reset the invocation, argument, etc #}
                    {% if method.isStatic and not method.isInitializer %} //MARK: - {{ method.shortName }}
                    {% if not method.isInitializer %}
                    {% call swiftifyMethodName method.selectorName %}CallsCount = 0
                    {% endif %}
                    {% if method.parameters.count == 1 %}
                    {% call swiftifyMethodName method.selectorName %}Received{% for param in method.parameters %}{{ param.name|upperFirstLetter }}{% endfor %} = nil
                    {% call swiftifyMethodName method.selectorName %}ReceivedInvocations = []
                    {% elif not method.parameters.count == 0 %}
                    {% call swiftifyMethodName method.selectorName %}ReceivedArguments = nil
                    {% call swiftifyMethodName method.selectorName %}ReceivedInvocations = []
                    {% endif %}
                    {% call methodClosureName method %} = nil
                    {% if method.throws %}
                    {% call swiftifyMethodName method.selectorName %}ThrowableError = nil
                    {% endif %}

                    {% endif %}

            {% endmacro %}

            {% macro mockOptionalVariable variable %}
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}: {% call existentialVariableTypeName variable.typeName %}
            {% endmacro %}

            {% macro mockNonOptionalArrayOrDictionaryVariable variable %}
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}: {% call existentialVariableTypeName variable.typeName %} = {% if variable.isArray %}[]{% elif variable.isDictionary %}[:]{% endif %}
            {% endmacro %}

            {% macro mockNonOptionalVariable variable %}
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}: {% call existentialVariableTypeName variable.typeName %} {
                    get { return {% call underlyingMockedVariableName variable %} }
                    set(value) { {% call underlyingMockedVariableName variable %} = value }
                }
                {% set wrappedTypeName %}{% if variable.typeName.isProtocolComposition %}({% call existentialVariableTypeName variable.typeName %}){% else %}{% call existentialVariableTypeName variable.typeName %}{% endif %}{% endset %}
                {% call accessLevel variable.readAccess %}var {% call underlyingMockedVariableName variable %}: ({% call existentialVariableTypeName wrappedTypeName %})!
            {% endmacro %}

            {% macro variableThrowableErrorDeclaration variable %}
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}ThrowableError: Error?
            {% endmacro %}

            {% macro variableThrowableErrorUsage variable %}
                        if let error = {% call mockedVariableName variable %}ThrowableError {
                            throw error
                        }
            {% endmacro %}

            {% macro variableClosureDeclaration variable %}
                {% call accessLevel variable.readAccess %}var {% call variableClosureName variable %}: (() {% if variable.isAsync %}async {% endif %}{% if variable.throws %}throws {% endif %}-> {% call existentialVariableTypeName variable.typeName %})?
            {% endmacro %}

            {% macro variableClosureName variable %}{% call mockedVariableName variable %}Closure{% endmacro %}

            {% macro mockAsyncOrThrowingVariable variable %}
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}CallsCount = 0
                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}Called: Bool {
                    return {% call mockedVariableName variable %}CallsCount > 0
                }

                {% call accessLevel variable.readAccess %}var {% call mockedVariableName variable %}: {% call existentialVariableTypeName variable.typeName %} {
                    get {% if variable.isAsync %}async {% endif %}{% if variable.throws %}throws {% endif %}{
                        {% if variable.throws %}
                        {% call variableThrowableErrorUsage variable %}
                        {% endif %}
                        {% call mockedVariableName variable %}CallsCount += 1
                        if let {% call variableClosureName variable %} = {% call variableClosureName variable %} {
                            return {{ 'try ' if variable.throws }}{{ 'await ' if variable.isAsync }}{% call variableClosureName variable %}()
                        } else {
                            return {% call underlyingMockedVariableName variable %}
                        }
                    }
                }
                {% call accessLevel variable.readAccess %}var {% call underlyingMockedVariableName variable %}: {% call existentialVariableTypeName variable.typeName %}{{ '!' if not variable.isOptional }}
                {% if variable.throws %}
                    {% call variableThrowableErrorDeclaration variable %}
                {% endif %}
                {% call variableClosureDeclaration method %}
            {% endmacro %}

            {% macro underlyingMockedVariableName variable %}underlying{{ variable.name|upperFirstLetter }}{% endmacro %}
            {% macro mockedVariableName variable %}{{ variable.name }}{% endmacro %}
            {% macro existentialVariableTypeName typeName %}{% if typeName|contains:"any" and typeName|contains:"!" %}{{ typeName | replace:"any","(any" | replace:"!",")!" }}{% elif typeName|contains:"any" and typeName.isOptional %}{{ typeName | replace:"any","(any" | replace:"?",")?" }}{% elif typeName|contains:"any" and typeName.isClosure %}({{ typeName | replace:"any","(any" | replace:"?",")?" }}){%else%}{{typeName}}{%endif%}{% endmacro %}
            {% macro existentialClosureVariableTypeName typeName %}{% if typeName|contains:"any" and typeName|contains:"!" %}{{ typeName | replace:"any","(any" | replace:"!",")?" }}{% elif typeName|contains:"any" and typeName.isClosure and typeName|contains:"?" %}{{ typeName | replace:"any","(any" | replace:"?",")?" }}{% elif typeName|contains:"any" and typeName|contains:"?" %}{{ typeName | replace:"any","(any" | replace:"?",")?" }}{%else%}{{typeName}}{%endif%}{% endmacro %}
            {% macro existentialParameterTypeName typeName %}{% if typeName|contains:"any" and typeName|contains:"!" %}{{ typeName | replace:"any","(any" | replace:"!",")!" }}{% elif typeName|contains:"any" and typeName.isClosure and typeName|contains:"?" %}{{ typeName | replace:"any","(any" | replace:"?",")?" }}{% elif typeName|contains:"any" and typeName.isOptional %}{{ typeName | replace:"any","(any" | replace:"?",")?" }}{%else%}{{typeName}}{%endif%}{% endmacro %}
            {% macro methodName method %}func {{ method.shortName}}({%- for param in method.parameters %}{% if param.argumentLabel == nil %}_ {{ param.name }}{%elif param.argumentLabel == param.name%}{{ param.name }}{%else%}{{ param.argumentLabel }} {{ param.name }}{% endif %}: {% call existentialParameterTypeName param.typeName %}{% if not forloop.last %}, {% endif %}{% endfor -%}){% endmacro %}
            {% macro typeNameOrAnyIfGeneric typeName %}
            {% for label, value in typeName %}
            {{label}} > {{value}}
            {%endfor%}
            {% endmacro %}

            {% for type in types.protocols where type.based.AutoMockable or type|annotated:"AutoMockable" %}{% if type.name != "AutoMockable" %}
            {% if type|annotated:"Available" %}
            @available({{ type.annotations.Available | replace:"[","" | replace:"]","" }}, *)
            {% endif %}
            {% if type|annotated:"Unavailable" %}
            @available({{ type.annotations.Unavailable }}, unavailable)
            {% endif %}
            {% call accessLevel type.accessLevel %}class {{ type.name }}Mock: {{ type.name }} {

                {% if type.accessLevel == "public" %}public init() {}{% endif %}

            {% for variable in type.allVariables|!definedInExtension %}
                {% if variable.isAsync or variable.throws %}{% call mockAsyncOrThrowingVariable variable %}{% elif variable.isOptional %}{% call mockOptionalVariable variable %}{% elif variable.isArray or variable.isDictionary %}{% call mockNonOptionalArrayOrDictionaryVariable variable %}{% else %}{% call mockNonOptionalVariable variable %}{% endif %}
            {% endfor %}

            {% if type.allMethods|static|count != 0 and type.allMethods|initializer|count != type.allMethods|static|count %}
                static func reset()
                {
                {% for method in type.allMethods|static %}
                    {% call resetMethod method %}
                {% endfor %}
                }
            {% endif %}

            {% for method in type.allMethods|!definedInExtension %}
                {% call mockMethod method %}
            {% endfor %}
            }
            {% endif %}{% endfor %}
            """
        )
    }
}
