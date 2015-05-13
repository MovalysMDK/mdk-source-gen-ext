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

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.uml.UmlAttribute;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

public class NullableBackwardCompatibiliyUmlUpdater extends AbstractUmlUpdater {

	/** Constant for model stereotype detection */
	private static final String STRING_MODEL_CONSTANT = "Mm_model";
	/** Old value to make attribute nullable (optional) */
	private static final String OLD_NULLABLE_OPTION = "_N";
	/** New value to make attribute nullable (optional) */
	private static final String NEW_OPTIONAL_OPTION = "_O";
	
	/** Class Logger */
	private static final Logger log = LoggerFactory.getLogger(NullableBackwardCompatibiliyUmlUpdater.class);
	
	/**
	 * {@inheritDoc}
	 * @see java.lang.Object#toString()
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception {
		
		log.debug("> Execute updater for Nullable attributes");
		
		//for all classes
		for (UmlClass oClass : p_oUmlModele.getDictionnary().getAllClasses()) {
			log.debug("  class: {}", oClass);
			for (String sStereotype : oClass.getStereotypeNames()) {
				log.debug("  stereotype: {}", sStereotype);
				// with stereotype "Mm_mpdel"
				if ( STRING_MODEL_CONSTANT.equals(sStereotype) ) {
					for (UmlAttribute oAttribute : oClass.getAttributes()) {
						log.debug("   attribute : {}", oAttribute.toString());
						log.debug("    name: {}", oAttribute.getName());
						log.debug("    class: {}", oAttribute.getClass());
						log.debug("    visibility: {}", oAttribute.getVisibility());
						log.debug("    datatype: {}", oAttribute.getDataType());
						log.debug("    init: {}", oAttribute.getInitialValue());
						log.debug("    documentation: {}", oAttribute.getDocumentation());
						
						String initValue = oAttribute.getInitialValue();
						if (initValue != null) {
							if ( initValue.contains(OLD_NULLABLE_OPTION) ) {
								
								// change option "_N" to "_O"
								initValue = initValue.replace(OLD_NULLABLE_OPTION, NEW_OPTIONAL_OPTION);
								oAttribute.setInitialValue(initValue);
								// fire warrning
								MessageHandler.getInstance().addWarning("Old attribute option {} replace by {}", OLD_NULLABLE_OPTION, NEW_OPTIONAL_OPTION);
							}
						}
					}
				}
			}
		}
		
		log.debug("< end updater");
	}

}
