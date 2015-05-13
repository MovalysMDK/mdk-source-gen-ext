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
 * <p>Ajoute dans le model uml l'attribut id, clé primaire de chaque classe portant le stéréotype "identifiable".</p>
 *
 * <p>Copyright (c) 2011</p>
 * <p>Company: Adeuza</p>
 *
 * @author fbourlieux
 * @since Annapurna
 */
public class AddUmlFieldIdSynchronizableUpdater extends AbstractUmlUpdater {

	/** Class Logger */
	private static final Logger log = LoggerFactory.getLogger(AddUmlFieldIdSynchronizableUpdater.class);
	/** The ID FROM SYNC stereotype in the UML model */
	private static final String IDSYCHRONIZABLE_STEREOTYPE = "Mm_idSynchronizable";
	/** the "admLastModificationUser" attribute*/
	private static final String SYNCID_ATTR = "syncId";
	/** the java documentation for the "admLastModificationUser" attribute */
	private static final String SYNCID_DOC = "the class identifier";
	/** the private attribute type */
	private static final String PUBLIC = "public";
	/** the default empty value */
	private static final String UNIQUE_OPTION = "_U";
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession) throws Exception {
		
		log.debug("> Execute updater for IDSYCHRONIZABLE stereotype");
		
		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		Collection<UmlClass> oUmlClassList = oUmlDictionnary.getAllClasses();
		// Etrange de modifier la collection issue du getAllClasses => devrait planter systématiquement.
		// De plus les classes d'association devrait et semblent être présente dans la collection renvoyée par getAllClasses
		//oUmlClassList.addAll(oUmlDictionnary.getAssociationClasses());
		
		UmlDataType oLongDataType = this.findUmlDataType(p_oUmlModele, UmlDataType.LONG);
		
		StringBuilder oBuilder = new StringBuilder();
		for (UmlClass oUmlClass : oUmlClassList) {
			if (oUmlClass.hasStereotype(IDSYCHRONIZABLE_STEREOTYPE)) {
				oBuilder.append("\n..............").append(oUmlClass.getName());
				oUmlClass.addAttribute(new UmlAttribute(SYNCID_ATTR, oUmlClass, PUBLIC, oLongDataType, UNIQUE_OPTION, SYNCID_DOC));
			}
		}
		
		if (oBuilder.length() > 0){
			log.debug("> [IDSYCHRONIZABLE MATCH] :"+oBuilder.toString());
			log.debug("< Execute updater for IDSYCHRONIZABLE stereotype");
		}else{
			log.debug("< No class match the IDSYCHRONIZABLE stereotype!");
		}
		
	}

}
