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

import java.util.Collection;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.uml.UmlAttribute;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlDataType;
import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

/**
 * <p>
 * Add ADM fields to all entity class
 * </p>
 * <p>
 * Copyright (c) 2009
 * <p>
 * Company: Adeuza
 * 
 * @author mmadigand
 * 
 */
public class AddUmlFieldsUpdater extends AbstractUmlUpdater {

	/** Logger for this class */
	private static final Logger log = LoggerFactory.getLogger(AddUmlFieldsUpdater.class);

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception {
		log.debug("> AddUmlFieldsUpdater.execute()");

		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		Collection<UmlClass> oUmlClassList = oUmlDictionnary.getAllClasses();
		oUmlClassList.addAll(oUmlDictionnary.getAssociationClasses());

		UmlDataType oStringDataType = p_oUmlModele.getDictionnary().getDataType("String_id");
		UmlDataType oLongDataType = p_oUmlModele.getDictionnary().getDataType("long_id");
		UmlDataType oTimestampDataType = p_oUmlModele.getDictionnary().getDataType("Timestamp_id");
		UmlDataType oIntDataType = p_oUmlModele.getDictionnary().getDataType("int_id");

		for (UmlClass oUmlClass : oUmlClassList) {
			oUmlClass.addAttribute(new UmlAttribute("admCreationKey", oUmlClass,
					"private", oStringDataType, "_255",
					"Ajouté par AddUmlFieldsUpdater"));
			oUmlClass.addAttribute(new UmlAttribute("admLastModificationDate", oUmlClass,
					"private", oTimestampDataType, "",
					"Ajouté par AddUmlFieldsUpdater"));
			oUmlClass.addAttribute(new UmlAttribute("admLastModificationUser", oUmlClass,
					"private", oLongDataType, "",
					"Ajouté par AddUmlFieldsUpdater"));
			oUmlClass.addAttribute(new UmlAttribute("admLivingRecord", oUmlClass,
					"private", oLongDataType, "",
					"Ajouté par AddUmlFieldsUpdater"));
			oUmlClass.addAttribute(new UmlAttribute("admVersion", oUmlClass, "private",
					oLongDataType, "", "Ajouté par AddUmlFieldsUpdater"));
			oUmlClass.addAttribute(new UmlAttribute("admTracking", oUmlClass, "private",
					oIntDataType, "", "Ajouté par AddUmlFieldsUpdater"));
		}

		log.debug("< AddUmlFieldsUpdater.execute()");
	}

}
