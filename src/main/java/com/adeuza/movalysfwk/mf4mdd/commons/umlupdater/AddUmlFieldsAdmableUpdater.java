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
 * <p>Ajoute dans le model uml les attributs <em>ADM</em>.</p>
 *
 * <p>Copyright (c) 2011</p>
 * <p>Company: Adeuza</p>
 *
 * @author fbourlieux
 * @since Annapurna
 */
public class AddUmlFieldsAdmableUpdater extends AbstractUmlUpdater {

	/** Class Logger */
	private static final Logger log = LoggerFactory.getLogger(AddUmlFieldsAdmableUpdater.class);
	/** The ADMABLE stereotype in the UML model */
	private static final String ADMABLE_STEREOTYPE = "Mm_admable";
	/** the "admCreationKey" attribute*/
	private static final String ADMCREATIONKEY_ATTR = "admCreationKey";
	/** the java documentation for the "admCreationKey" attribute */
	private static final String ADMCREATIONKEY_DOC = "creation key";
	/** the "admLastModificationDate" attribute*/
	private static final String ADMLASTMODIFICATIONDATE_ATTR = "admLastModificationDate";
	/** the java documentation for the "admLastModificationDate" attribute */
	private static final String ADMLASTMODIFICATIONDATE_DOC = "the last modification date of this object";
	/** the "admLastModificationUser" attribute*/
	private static final String ADMLASTMODIFICATIONUSER_ATTR = "admLastModificationUser";
	/** the java documentation for the "admLastModificationUser" attribute */
	private static final String ADMLASTMODIFICATIONUSER_DOC = "the last user that has modified this object";
	/** the "admLivingRecord" attribute*/
	private static final String ADMLIVINGRECORD_ATTR = "admLivingRecord";
	/** the java documentation for the "admLivingRecord" attribute */
	private static final String ADMLIVINGRECORD_DOC = "this object is it always living";
	/** the "admVersion" attribute*/
	private static final String ADMVERSION_ATTR = "admVersion";
	/** the java documentation for the "admVersion" attribute */
	private static final String ADMVERSION_DOC = "the version of this object";
	/** the "admTracking" attribute*/
	private static final String ADMTRACKING_ATTR = "admTracking";
	/** the java documentation for the "admTracking" attribute */
	private static final String ADMTRACKING_DOC = "the flag of this object";
	/** the private attribute type */
	private static final String PUBLIC = "public";
	/** the default empty value */
	private static final String EMPTY = "";
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession) throws Exception {
		
		log.debug("> Execute updater for ADMABLE stereotype");
		
		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		Collection<UmlClass> oUmlClassList = oUmlDictionnary.getAllClasses();
		// Etrange de modifier la collection issue du getAllClasses => devrait planter systématiquement.
		// De plus les classes d'association devrait et semblent être présente dans la collection renvoyée par getAllClasses
		// oUmlClassList.addAll(oUmlDictionnary.getAssociationClasses());

		UmlDataType oStringDataType = this.findUmlDataType(p_oUmlModele, UmlDataType.STRING);
		UmlDataType oLongDataType = this.findUmlDataType(p_oUmlModele, UmlDataType.LONG);
		UmlDataType oIntDataType = this.findUmlDataType(p_oUmlModele, UmlDataType.INT);
		UmlDataType oTimestampDataType = this.findUmlDataType(p_oUmlModele, UmlDataType.DATE);
		
		StringBuilder oBuilder = new StringBuilder();
		for (UmlClass oUmlClass : oUmlClassList) {
			if (oUmlClass.hasStereotype(ADMABLE_STEREOTYPE)) {
				oBuilder.append("\n..............").append(oUmlClass.getName());
				oUmlClass.addAttribute(new UmlAttribute(ADMCREATIONKEY_ATTR, oUmlClass, PUBLIC, oStringDataType, "_255", ADMCREATIONKEY_DOC));
				oUmlClass.addAttribute(new UmlAttribute(ADMLASTMODIFICATIONDATE_ATTR, oUmlClass, PUBLIC, oTimestampDataType, EMPTY, ADMLASTMODIFICATIONDATE_DOC));
				oUmlClass.addAttribute(new UmlAttribute(ADMLASTMODIFICATIONUSER_ATTR, oUmlClass, PUBLIC, oLongDataType, EMPTY, ADMLASTMODIFICATIONUSER_DOC));
				oUmlClass.addAttribute(new UmlAttribute(ADMLIVINGRECORD_ATTR, oUmlClass, PUBLIC, oLongDataType, EMPTY, ADMLIVINGRECORD_DOC));
				oUmlClass.addAttribute(new UmlAttribute(ADMVERSION_ATTR, oUmlClass, PUBLIC,oLongDataType, EMPTY, ADMVERSION_DOC));
				oUmlClass.addAttribute(new UmlAttribute(ADMTRACKING_ATTR, oUmlClass, PUBLIC,oIntDataType, EMPTY, ADMTRACKING_DOC));
			}
		}
		
		if (oBuilder.length() > 0){
			log.debug("> [ADMABLE MATCH] :"+oBuilder.toString());
			log.debug("< Execute updater for ADMABLE stereotype");
		}else{
			log.debug("< No class match the ADMABLE stereotype!");
		}
	}

}
