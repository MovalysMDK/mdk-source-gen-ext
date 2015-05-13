/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.umlupdater;

import java.util.Arrays;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.uml.UmlAttribute;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

/**
 * <p>Avertit à la génération des types UML n'acceptant pas des valeurs par défauts flottantes.
 * Indique si la valeur par défaut n'est pas correcte
 *
 * <p>Copyright (c) 2014</p>
 * <p>Company: Adeuza</p>
 *
 * @author qlagarde
 */
public class DefaultValueUmlUpdater extends AbstractUmlUpdater {

	/** Class Logger */
	private static final Logger log = LoggerFactory.getLogger(DefaultValueUmlUpdater.class);

	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception {

		log.debug("> Execute updater for default values ");

		for (String oFixedDefaultValuesType : this.getParametersMap().keySet()) {
			log.debug("default values for : "+ oFixedDefaultValuesType);
			for(UmlClass oUmlModelClass : p_oUmlModele.getDictionnary().getAllClasses()) {

				log.debug("Parsing Uml Class : "+ oUmlModelClass.getName());
				for(UmlAttribute oUmlModelAttribute : oUmlModelClass.getAttributes()) {

					log.debug("Parsing Uml Class attribute : "+ oUmlModelAttribute.getName());
					String attributeTypeName = null;
					if(oUmlModelAttribute.getDataType() != null)
						attributeTypeName = oUmlModelAttribute.getDataType().getName();

					log.debug("DATATYPE :  "+ attributeTypeName);
					if(oFixedDefaultValuesType.equals(attributeTypeName)) {
						
						//Récupération de la valeur initiale. elle peut être de type "", "_O" etc...(des options), 
						//"ABCDEF" (une vraie valeur initiale) ou "ABCDEF_O_X" (une valeur initiale + des options)
						//On ne veut récupérer que la valeur sans les options.
						String[] oUserDefaultValueComponents = oUmlModelAttribute.getInitialValue().split("_");
						String oUserDefaultValue = null;
						if(oUserDefaultValueComponents.length > 0) {
							oUserDefaultValue = oUserDefaultValueComponents[0];
						}
						//Get Authorized values for the current type
						String[] oAuthorizedValues = this.getParametersMap().get(oFixedDefaultValuesType).split(",");

						if(oUserDefaultValue != null && !oUserDefaultValue.isEmpty()) {
							if( !Arrays.asList(oAuthorizedValues).contains(oUserDefaultValue) ) {
								MessageHandler.getInstance().addError("The attribute \'{}\' has an incorrect initial value : \'{}\'. Correct values for the type \'{}\' are : {}", 
										oUmlModelAttribute.getName(), oUserDefaultValue, attributeTypeName, Arrays.asList(oAuthorizedValues).toString());
							}
						}
						else {
							if(oUserDefaultValue.isEmpty()) {
								MessageHandler.getInstance().addWarning("You should specify a default value : {} for the attribute \'{}\' of type \'{}\'", 
										Arrays.asList(oAuthorizedValues).toString(), oUmlModelAttribute.getName(), attributeTypeName);
							}
						}
					}
				}
			}
		}
		log.debug("< end updater");
	}

}
