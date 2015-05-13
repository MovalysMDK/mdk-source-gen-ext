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
 * Ajoute dans le fichier uml les champs dynamiques de cache sur les entités
 * portant le stéréotype dynamicable
 * </p>
 * <p>
 * Copyright (c) 2009
 * <p>
 * Company: Adeuza
 * 
 * @author smaitre
 * 
 */
public class AddUmlFieldsDynamicalCacheUpdater extends AbstractUmlUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory
			.getLogger(AddUmlFieldsDynamicalCacheUpdater.class);

	/**
	 * non du stéréotype indiquant qu'une entité en dynamique
	 */
	public static String DYNAMICABLE_STEREOTYPE_NAME = "dynamicable";

	/**
	 * nb cache par entité
	 */
	public static int NB_CACHE_BY_ENTITY = 10;

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.umlupdater.UmlUpdater#execute(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.uml.UmlModel, java.util.Map)
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception {
		log.debug("> AddUmlFieldsDynamicalCacheUpdater.execute()");

		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		Collection<UmlClass> oUmlClassList = oUmlDictionnary.getAllClasses();

		UmlDataType oStringDataType = p_oUmlModele.getDictionnary()
				.getDataType("String_id");

		for (UmlClass oUmlClass : oUmlClassList) {
			if (oUmlClass.hasStereotype(DYNAMICABLE_STEREOTYPE_NAME)) {
				for (int i = 0; i < NB_CACHE_BY_ENTITY; i++) {
					oUmlClass.addAttribute(new UmlAttribute("cacheValue"
							+ String.valueOf(i), oUmlClass, "private", oStringDataType,
							"_255_R_N",
							"Added by AddUmlFieldsDynamicalCacheUpdater"));
					oUmlClass.addAttribute(new UmlAttribute("cacheI18nValue"
							+ String.valueOf(i), oUmlClass, "private", oStringDataType,
							"_255_R_N",
							"Added by AddUmlFieldsDynamicalCacheUpdater"));
				}
			}
		}

		log.debug("< AddUmlFieldsUpdater.execute()");
	}

}
